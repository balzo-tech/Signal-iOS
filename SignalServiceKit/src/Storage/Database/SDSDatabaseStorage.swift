//
//  Copyright (c) 2021 Open Whisper Systems. All rights reserved.
//

import Foundation
import PromiseKit

@objc
public protocol SDSDatabaseStorageDelegate {
    var storageCoordinatorState: StorageCoordinatorState { get }
}

// MARK: -

@objc
public class SDSDatabaseStorage: SDSTransactable {

    private weak var delegate: SDSDatabaseStorageDelegate?

    static public var shouldLogDBQueries: Bool = DebugFlags.logSQLQueries

    private var hasPendingCrossProcessWrite = false

    private let crossProcess = SDSCrossProcess()

    // MARK: - Initialization / Setup

    private var _grdbStorage: GRDBDatabaseStorageAdapter?

    @objc
    public var grdbStorage: GRDBDatabaseStorageAdapter {
        if let storage = _grdbStorage {
            return storage
        } else {
            let storage = createGrdbStorage()
            _grdbStorage = storage
            return storage
        }
    }

    @objc
    required init(delegate: SDSDatabaseStorageDelegate) {
        self.delegate = delegate

        super.init()

        addObservers()
    }

    private func addObservers() {
        guard !CurrentAppContext().isRunningTests else {
            return
        }
        owsAssertDebug(StorageCoordinator.dataStoreForUI == .grdb)
        // Cross process writes
        crossProcess.callback = { [weak self] in
            DispatchQueue.main.async {
                self?.handleCrossProcessWrite()
            }
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }

    deinit {
        Logger.verbose("")

        NotificationCenter.default.removeObserver(self)
    }

    private class func baseDir() -> URL {
        return URL(fileURLWithPath: CurrentAppContext().appDatabaseBaseDirectoryPath(),
                   isDirectory: true)
    }

    @objc
    public static var grdbDatabaseDirUrl: URL {
        return GRDBDatabaseStorageAdapter.databaseDirUrl(baseDir: baseDir())
    }

    @objc
    public static var grdbDatabaseFileUrl: URL {
        return GRDBDatabaseStorageAdapter.databaseFileUrl(baseDir: baseDir())
    }

    @objc
    public static let storageDidReload = Notification.Name("storageDidReload")

    // completion is performed on the main queue.
    @objc
    public func runGrdbSchemaMigrations(completion: @escaping () -> Void) {
        guard storageCoordinatorState == .GRDB else {
            owsFailDebug("Not GRDB.")
            return
        }

        Logger.info("")

        let didPerformIncrementalMigrations = GRDBSchemaMigrator().runSchemaMigrations()

        Logger.info("didPerformIncrementalMigrations: \(didPerformIncrementalMigrations)")

        if didPerformIncrementalMigrations {
            let benchSteps = BenchSteps()

            // There seems to be a rare issue where at least one reader or writer
            // (e.g. SQLite connection) in the GRDB pool ends up "stale" after
            // a schema migration and does not reflect the migrations.
            grdbStorage.pool.releaseMemory()
            weak var weakPool = grdbStorage.pool
            weak var weakGrdbStorage = grdbStorage
            owsAssertDebug(weakPool != nil)
            owsAssertDebug(weakGrdbStorage != nil)
            _grdbStorage = createGrdbStorage()

            DispatchQueue.main.async {
                // We want to make sure all db connections from the old adapter/pool are closed.
                //
                // We only reach this point by a predictable code path; the autoreleasepool
                // should be drained by this point.
                owsAssertDebug(weakPool == nil)
                owsAssertDebug(weakGrdbStorage == nil)

                benchSteps.step("New GRDB adapter.")

                completion()
            }
        } else {
            DispatchQueue.main.async(execute: completion)
        }
    }

    public func reload() {
        AssertIsOnMainThread()
        assert(storageCoordinatorState == .GRDB)

        Logger.info("")

        let wasRegistered = TSAccountManager.shared.isRegistered

        let grdbStorage = createGrdbStorage()
        _grdbStorage = grdbStorage

        GRDBSchemaMigrator().runSchemaMigrations()
        grdbStorage.forceUpdateSnapshot()

        // We need to do this _before_ warmCaches().
        NotificationCenter.default.post(name: Self.storageDidReload, object: nil, userInfo: nil)

        SSKEnvironment.shared.warmCaches()

        if wasRegistered != TSAccountManager.shared.isRegistered {
            NotificationCenter.default.post(name: .registrationStateDidChange, object: nil, userInfo: nil)
        }
    }

    func createGrdbStorage() -> GRDBDatabaseStorageAdapter {
        return Bench(title: "Creating GRDB storage") {
            return GRDBDatabaseStorageAdapter(baseDir: type(of: self).baseDir())
        }
    }

    @objc
    public func deleteGrdbFiles() {
        GRDBDatabaseStorageAdapter.removeAllFiles(baseDir: type(of: self).baseDir())
    }

    @objc
    public func resetAllStorage() {
        YDBStorage.deleteYDBStorage()
        GRDBDatabaseStorageAdapter.resetAllStorage(baseDir: type(of: self).baseDir())
    }

    // MARK: - Observation

    @objc
    public func appendUIDatabaseSnapshotDelegate(_ snapshotDelegate: UIDatabaseSnapshotDelegate) {
        guard let uiDatabaseObserver = grdbStorage.uiDatabaseObserver else {
            owsFailDebug("Missing uiDatabaseObserver.")
            return
        }
        uiDatabaseObserver.appendSnapshotDelegate(snapshotDelegate)
    }

    // MARK: - UI Database Snapshot Completion

    @objc
    public func add(uiDatabaseSnapshotFlushBlock: @escaping () -> Void) {
        guard AppReadiness.isAppReady else {
            owsFailDebug("App not ready.")
            return
        }
        guard let uiDatabaseObserver = grdbStorage.uiDatabaseObserver else {
            owsFailDebug("Missing uiDatabaseObserver")
            return
        }
        uiDatabaseObserver.add(snapshotFlushBlock: uiDatabaseSnapshotFlushBlock)
    }

    public func uiDatabaseSnapshotFlushPromise() -> Promise<Void> {
        let (promise, resolver) = Promise<Void>.pending()

        add(uiDatabaseSnapshotFlushBlock: {
            resolver.fulfill(())
        })

        return firstly {
            promise
        }.timeout(seconds: 30)
    }

    // MARK: - Id Mapping

    @objc
    public func updateIdMapping(thread: TSThread, transaction: SDSAnyWriteTransaction) {
        switch transaction.writeTransaction {
        case .grdbWrite(let grdb):
            UIDatabaseObserver.serializedSync {
                if let uiDatabaseObserver = grdbStorage.uiDatabaseObserver {
                    uiDatabaseObserver.updateIdMapping(thread: thread, transaction: grdb)
                } else if AppReadiness.isAppReady {
                    owsFailDebug("uiDatabaseObserver was unexpectedly nil")
                }
            }
        }
    }

    @objc
    public func updateIdMapping(interaction: TSInteraction, transaction: SDSAnyWriteTransaction) {
        switch transaction.writeTransaction {
        case .grdbWrite(let grdb):
            UIDatabaseObserver.serializedSync {
                if let uiDatabaseObserver = grdbStorage.uiDatabaseObserver {
                    uiDatabaseObserver.updateIdMapping(interaction: interaction, transaction: grdb)
                } else if AppReadiness.isAppReady {
                    owsFailDebug("uiDatabaseObserver was unexpectedly nil")
                }
            }
        }
    }

    @objc
    public func updateIdMapping(attachment: TSAttachment, transaction: SDSAnyWriteTransaction) {
        switch transaction.writeTransaction {
        case .grdbWrite(let grdb):
            UIDatabaseObserver.serializedSync {
                if let uiDatabaseObserver = grdbStorage.uiDatabaseObserver {
                    uiDatabaseObserver.updateIdMapping(attachment: attachment, transaction: grdb)
                } else if AppReadiness.isAppReady {
                    owsFailDebug("uiDatabaseObserver was unexpectedly nil")
                }
            }
        }
    }

    // MARK: - Touch

    @objc(touchInteraction:shouldReindex:transaction:)
    public func touch(interaction: TSInteraction, shouldReindex: Bool, transaction: SDSAnyWriteTransaction) {
        switch transaction.writeTransaction {
        case .grdbWrite(let grdb):
            UIDatabaseObserver.serializedSync {
                guard !UIDatabaseObserver.skipTouchObservations else {
                    return
                }

                if let uiDatabaseObserver = grdbStorage.uiDatabaseObserver {
                    uiDatabaseObserver.didTouch(interaction: interaction, transaction: grdb)
                } else if AppReadiness.isAppReady {
                    owsFailDebug("uiDatabaseObserver was unexpectedly nil")
                }
                if shouldReindex {
                    GRDBFullTextSearchFinder.modelWasUpdated(model: interaction, transaction: grdb)
                }
            }
        }
    }

    @objc(touchThread:shouldReindex:transaction:)
    public func touch(thread: TSThread, shouldReindex: Bool, transaction: SDSAnyWriteTransaction) {
        switch transaction.writeTransaction {
        case .grdbWrite(let grdb):
            UIDatabaseObserver.serializedSync {
                guard !UIDatabaseObserver.skipTouchObservations else {
                    return
                }

                if let uiDatabaseObserver = grdbStorage.uiDatabaseObserver {
                    uiDatabaseObserver.didTouch(thread: thread, transaction: grdb)
                } else if AppReadiness.isAppReady {
                    // This can race with observation setup when app becomes ready.
                    Logger.warn("uiDatabaseObserver was unexpectedly nil")
                }
                if shouldReindex {
                    GRDBFullTextSearchFinder.modelWasUpdated(model: thread, transaction: grdb)
                }
            }
        }
    }

    // MARK: - Cross Process Notifications

    private func handleCrossProcessWrite() {
        AssertIsOnMainThread()

        Logger.info("")

        guard CurrentAppContext().isMainApp else {
            return
        }

        if CurrentAppContext().isMainAppAndActive {
            // If already active, update immediately.
            postCrossProcessNotification()
        } else {
            // If not active, set flag to update when we become active.
            hasPendingCrossProcessWrite = true
        }
    }

    @objc func didBecomeActive() {
        AssertIsOnMainThread()

        guard hasPendingCrossProcessWrite else {
            return
        }
        hasPendingCrossProcessWrite = false

        postCrossProcessNotification()
    }

    @objc
    public static let didReceiveCrossProcessNotification = Notification.Name("didReceiveCrossProcessNotification")

    private func postCrossProcessNotification() {
        Logger.info("")

        // TODO: The observers of this notification will inevitably do
        //       expensive work.  It'd be nice to only fire this event
        //       if this had any effect, if the state of the database
        //       has changed.
        //
        //       In the meantime, most (all?) cross process write notifications
        //       will be delivered to the main app while it is inactive. By
        //       de-bouncing notifications while inactive and only updating
        //       once when we become active, we should be able to effectively
        //       skip most of the perf cost.
        NotificationCenter.default.postNotificationNameAsync(SDSDatabaseStorage.didReceiveCrossProcessNotification, object: nil)
    }

    // MARK: - SDSTransactable

    @objc
    public func uiRead(block: (SDSAnyReadTransaction) -> Void) {
        do {
            try grdbStorage.uiRead { transaction in
                block(transaction.asAnyRead)
            }
        } catch {
            owsFail("error: \(error.grdbErrorForLogging)")
        }
    }

    @objc
    public override func read(block: (SDSAnyReadTransaction) -> Void) {
        do {
            try grdbStorage.read { transaction in
                block(transaction.asAnyRead)
            }
        } catch {
            owsFail("error: \(error.grdbErrorForLogging)")
        }
    }

    // NOTE: This method is not @objc. See SDSDatabaseStorage+Objc.h.
    public override func write(file: String = #file,
                               function: String = #function,
                               line: Int = #line,
                               block: (SDSAnyWriteTransaction) -> Void) {
        #if TESTABLE_BUILD
        if Thread.isMainThread &&
            AppReadiness.isAppReady {
            Logger.warn("Database write on main thread.")
        }
        #endif

        let benchTitle = "Slow Write Transaction \(Self.owsFormatLogMessage(file: file, function: function, line: line))"
        do {
            try grdbStorage.write { transaction in
                Bench(title: benchTitle, logIfLongerThan: 0.1, logInProduction: DebugFlags.internalLogging) {
                    block(transaction.asAnyWrite)
                }
            }
        } catch {
            owsFail("error: \(error.grdbErrorForLogging)")
        }
        crossProcess.notifyChangedAsync()
    }

    public func uiReadThrows(block: (SDSAnyReadTransaction) throws -> Void) throws {
        try grdbStorage.uiReadThrows { transaction in
            try autoreleasepool {
                try block(transaction.asAnyRead)
            }
        }
    }

    public func uiRead<T>(block: (SDSAnyReadTransaction) -> T) -> T {
        var value: T!
        uiRead { (transaction) in
            value = block(transaction)
        }
        return value
    }

    public static func owsFormatLogMessage(file: String = #file,
                                           function: String = #function,
                                           line: Int = #line) -> String {
        let filename = (file as NSString).lastPathComponent
        // We format the filename & line number in a format compatible
        // with XCode's "Open Quickly..." feature.
        return "[\(filename):\(line) \(function)]"
    }
}

// MARK: - Coordination

extension SDSDatabaseStorage {

    private var storageCoordinatorState: StorageCoordinatorState {
        guard let delegate = delegate else {
            owsFail("Missing delegate.")
        }
        return delegate.storageCoordinatorState
    }

    private var storageCoordinatorStateDescription: String {
        NSStringFromStorageCoordinatorState(storageCoordinatorState)
    }
}

// MARK: -

protocol SDSDatabaseStorageAdapter {
    associatedtype ReadTransaction
    associatedtype WriteTransaction
    func uiRead(block: (ReadTransaction) -> Void) throws
    func read(block: (ReadTransaction) -> Void) throws
    func write(block: (WriteTransaction) -> Void) throws
}

// MARK: -

@objc
public class SDS: NSObject {
    @objc
    public class func fitsInInt64(_ value: UInt64) -> Bool {
        return value <= Int64.max
    }

    @objc
    public func fitsInInt64(_ value: UInt64) -> Bool {
        return SDS.fitsInInt64(value)
    }

    @objc(fitsInInt64WithNSNumber:)
    public class func fitsInInt64(nsNumber value: NSNumber) -> Bool {
        return fitsInInt64(value.uint64Value)
    }

    @objc(fitsInInt64WithNSNumber:)
    public func fitsInInt64(nsNumber value: NSNumber) -> Bool {
        return SDS.fitsInInt64(nsNumber: value)
    }
}

// MARK: -

@objc
public extension SDSDatabaseStorage {
    func logFileSizes() {
        Logger.info("Database : \(databaseFileSize)")
        Logger.info("\t WAL file size: \(databaseWALFileSize)")
        Logger.info("\t SHM file size: \(databaseSHMFileSize)")
    }

    func logAllFileSizes() {
        Logger.info("GDRB Database : \(grdbStorage.databaseFileSize)")
        Logger.info("\t GDRB WAL file size: \(grdbStorage.databaseWALFileSize)")
        Logger.info("\t GDRB SHM file size: \(grdbStorage.databaseSHMFileSize)")
    }

    var databaseFileSize: UInt64 {
        grdbStorage.databaseFileSize
    }

    var databaseWALFileSize: UInt64 {
        grdbStorage.databaseWALFileSize
    }

    var databaseSHMFileSize: UInt64 {
        grdbStorage.databaseSHMFileSize
    }
}

//
//  Copyright (c) 2021 Attimo Srl. All rights reserved.
//

import Foundation

class ProjectInfo {
    
    private enum ProjectInfoKey: String, CaseIterable {
        case stripeTestKey = "stripe_test_key"
        case stripeProductionKey = "stripe_production_key"
    }
    
    static var StripeTestKey: String { Self.getValue(forKey: .stripeTestKey, defaultValue: "") }
    static var StripeProductionKey: String { Self.getValue(forKey: .stripeProductionKey, defaultValue: "") }
    
    static func validate() {
        ProjectInfoKey.allCases.forEach { key in
            switch key {
            case .stripeTestKey: _ = Self.getValue(forKey: key, defaultValue: "")
            case .stripeProductionKey: _ = Self.getValue(forKey: key, defaultValue: "")
            }
        }
    }
    
    // MARK: - Private Methods
    
    static private var projectInfoDictionary: [String: Any] = {
        guard let url = Bundle.main.url(forResource: "ProjectInfo", withExtension: "plist") else {
            assertionFailure("Couldn't find ProjectInfo.plist")
            return [:]
        }
        guard let data = try? Data(contentsOf: url) else {
            assertionFailure("Couldn't open ProjectInfo.plist")
            return [:]
        }
        guard let studyConfig = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any] else {
            assertionFailure("ProjectInfo.plist is not a dictionary of [String: Any]")
            return [:]
        }
        return studyConfig
    }()
    
    static private func getValue<T>(forKey key: ProjectInfoKey, defaultValue: T) -> T {
        guard let object = Self.projectInfoDictionary[key.rawValue], let value = object as? T  else {
            assertionFailure("Couldn't find \(key.rawValue) in ProjectInfo")
            return defaultValue
        }
        return value
    }
}

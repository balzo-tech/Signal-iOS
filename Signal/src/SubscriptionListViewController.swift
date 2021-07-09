//
//  Copyright (c) 2021 Attimo Srl. All rights reserved.
//

import Foundation
import UIKit

class SubscriptionListViewController: OWSViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = Theme.backgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = Theme.cellSeparatorColor
        tableView.register(SubscriptionListCell.self, forCellReuseIdentifier: SubscriptionListCell.cellReuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private var subscriptions: [Subscription] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("SUBSCRIPTION_LIST_TITLE", comment: "Title of SubscriptionListViewController.")
        
        self.view.addSubview(self.tableView)
        self.tableView.autoPinEdgesToSuperviewEdges()
        
        let pullToRefreshView = UIRefreshControl()
        pullToRefreshView.tintColor = UIColor.gray
        pullToRefreshView.addTarget(self, action: #selector(self.pullToRefreshPerformed), for: .valueChanged)
        self.tableView.refreshControl = pullToRefreshView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.backBarButtonItem = .init(title: "   ", style: .plain, target: nil, action: nil)
        
        self.refreshContents()
    }
    
    // MARK: - Private Methods
    
    private func refreshContents() {
        AppEnvironment.shared.subscriptionManagerRef.getSubscriptionList()
            .done { [weak self] subscriptions in
                AssertIsOnMainThread()
                self?.subscriptions = subscriptions
                self?.tableView.reloadData()
            }.catch { error in
                AssertIsOnMainThread()
                owsFailDebug("Error: \(error)")
                OWSActionSheets.showActionSheet(title: NSLocalizedString("ALERT_ERROR_TITLE", comment: "Generic error indicator"),
                                                message: NSLocalizedString("ERROR_DESCRIPTION_UNKNOWN_ERROR", comment: "Worst case generic error message"))
            }
    }
    
    // MARK: - Actions
    
    @objc private func pullToRefreshPerformed() {
        self.refreshContents()
    }
}

extension SubscriptionListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subscriptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: SubscriptionListCell.cellReuseIdentifier, for: indexPath)
        
        guard let subscriptionCell = cell as? SubscriptionListCell else {
            owsFailDebug("unexpected cell type")
            return cell
        }
        
        guard let subscription = self.subscriptions[safe: indexPath.row] else {
            owsFailDebug("missing subscription")
            return cell
        }
        subscriptionCell.debugConfigure(withSubscription: subscription, groupName: "Test Group Name")
        
        return subscriptionCell
    }
}

extension SubscriptionListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let subscription = self.subscriptions[safe: indexPath.row] else {
            owsFailDebug("missing subscription")
            return
        }
        let vc = SubscriptionViewController(withDebugData: DebugSubscriptionViewModel(groupName: "Test Group Name", subscription: subscription))
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

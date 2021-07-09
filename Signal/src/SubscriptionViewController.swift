//
//  Copyright (c) 2021 Attimo Srl. All rights reserved.
//

import Foundation
import UIKit

struct DebugSubscriptionViewModel {
    let groupName: String
    let subscription: Subscription
}

class SubscriptionViewController: OWSViewController {
    
    private var threadViewModel: ThreadViewModel?

    private var thread: TSThread? {
        self.threadViewModel?.threadRecord
    }

    // Group model reflecting the last known group state.
    // This is updated as we change group membership, etc.
    private var currentGroupModel: TSGroupModel? {
        guard let groupThread = self.thread as? TSGroupThread else {
            return nil
        }
        return groupThread.groupModel
    }
    
    /// This should be used only to test UI
    private var debugData: DebugSubscriptionViewModel?
    
    private let subscriptionHintLabel: UILabel = {
        let text = NSLocalizedString("SUBSCRIPTION_HINT", comment: "Subscription hint in SubscriptionViewController.")
        let label = UILabel()
        label.text = text
        label.textColor = Theme.isDarkThemeEnabled ? UIColor.ows_gray400 : UIColor.ows_gray500
        label.font = UIFont.ows_dynamicTypeCaption1
        return label
    }()
    
    private lazy var groupAvatarView: AvatarView = {
        let view = AvatarView()
        if let threadViewModel = self.threadViewModel {
            view.update(withThreadViewModel: threadViewModel)
        } else if let debugData = self.debugData {
            view.debugUpdate(name: debugData.groupName)
        }
        return view
    }()
    
    private let subscriptionPlanHintLabel: UILabel = {
        let text = NSLocalizedString("SUBSCRIPTION_OPTIONS", comment: "Subscription options hint in SubscriptionViewController.")
        let label = UILabel()
        label.text = text
        label.textColor = Theme.isDarkThemeEnabled ? UIColor.ows_gray400 : UIColor.ows_gray500
        label.font = UIFont.ows_dynamicTypeCaption1
        return label
    }()
    
    private lazy var subscriptionPlanView: SubscriptionPlanView = {
        let view = SubscriptionPlanView()
        if let subscription = self.threadViewModel?.subscription {
            view.update(withSubscription: subscription)
        } else if let debugData = self.debugData {
            view.update(withSubscription: debugData.subscription)
        }
        return view
    }()
    
    private lazy var unsubscribeButton: UIButton = {
        let buttonHeight: CGFloat = 44
        let button = UIButton()
        let text = NSLocalizedString("SUBSCRIPTION_UNSUBSCRIBE_BUTTON", comment: "Unsubscribe button SubscriptionViewController.")
        button.setTitle(text, for: .normal)
        button.setTitleColor(UIColor.ows_redRibbon500, for: .normal)
        button.titleLabel?.font = UIFont.ows_dynamicTypeTitle3
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(self.unsubscribeButtonPressed), for: .touchUpInside)
        button.autoSetDimension(.height, toSize: 60.0)
        return button
    }()
    
    private let infoLabel: UILabel = {
        let text = NSLocalizedString("SUBSCRIPTION_INFO", comment: "Subscription info in SubscriptionViewController.")
        let label = UILabel()
        label.text = text
        label.textColor = Theme.isDarkThemeEnabled ? UIColor.ows_gray400 : UIColor.ows_gray500
        label.font = UIFont.ows_dynamicTypeCaption1
        label.numberOfLines = 0
        return label
    }()
    
    init(withThreadViewModel threadViewModel: ThreadViewModel) {
        self.threadViewModel = threadViewModel
        super.init()
    }
    
    init(withDebugData debugData: DebugSubscriptionViewModel) {
        self.debugData = debugData
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("SUBSCRIPTION_TITLE", comment: "Title of SubscriptionViewController.")
        self.view.backgroundColor = Theme.backgroundColor
        
        let scrollView = UIScrollView()
        self.view.addSubview(scrollView)
        scrollView.autoPinEdgesToSuperviewEdges()
        
        // StackView
        let stackView = UIStackView()
        stackView.axis = .vertical
        scrollView.addSubview(stackView)
        stackView.autoPinEdgesToSuperviewEdges()
        stackView.autoAlignAxis(toSuperviewAxis: .vertical)
        
        stackView.addBlankSpace(space: 32.0)
        stackView.addContentView(self.subscriptionHintLabel)
        stackView.addBlankSpace(space: 8.0)
        stackView.addSeparatorView()
        stackView.addBlankSpace(space: 10.0)
        stackView.addContentView(self.groupAvatarView)
        stackView.addBlankSpace(space: 10.0)
        stackView.addSeparatorView()
        stackView.addBlankSpace(space: 32.0)
        stackView.addContentView(self.subscriptionPlanHintLabel)
        stackView.addBlankSpace(space: 8.0)
        stackView.addSeparatorView()
        stackView.addBlankSpace(space: 12.0)
        stackView.addContentView(self.subscriptionPlanView)
        stackView.addBlankSpace(space: 12.0)
        stackView.addSeparatorView()
        stackView.addBlankSpace(space: 24.0)
        stackView.addSeparatorView()
        stackView.addBlankSpace(space: 5.0)
        stackView.addContentView(self.unsubscribeButton)
        stackView.addBlankSpace(space: 5.0)
        stackView.addSeparatorView()
        stackView.addBlankSpace(space: 12.0)
        stackView.addContentView(self.infoLabel)
        stackView.addBlankSpace(space: 12.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.backBarButtonItem = .init(title: "   ", style: .plain, target: nil, action: nil)
    }
    
    // MARK: - Actions
    
    @objc func unsubscribeButtonPressed() {
        // TODO: Unsubscribe
        OWSActionSheets.showActionSheet(title: NSLocalizedString("ALERT_ERROR_TITLE", comment: "Generic error indicator"),
                                        message: "To be implemented")
    }
}

fileprivate extension UIStackView {
    func addSeparatorView() {
        self.addSeparatorView(withColor: Theme.cellSeparatorColor)
    }
    
    func addContentView(_ view: UIView) {
        self.addArrangedSubview(view, horizontalInset: 20.0)
    }
}

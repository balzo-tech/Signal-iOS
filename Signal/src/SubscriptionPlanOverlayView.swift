//
//  Copyright (c) 2021 Attimo Srl. All rights reserved.
//

import UIKit

@objc
class SubscriptionPlanOverlayView: UIView {

    private var threadViewModel: ThreadViewModel

    private var thread: TSThread {
        self.threadViewModel.threadRecord
    }

    // Group model reflecting the last known group state.
    // This is updated as we change group membership, etc.
    private var currentGroupModel: TSGroupModel? {
        guard let groupThread = self.thread as? TSGroupThread else {
            return nil
        }
        return groupThread.groupModel
    }
    
    @objc
    init(withThreadViewModel threadViewModel: ThreadViewModel) {
        self.threadViewModel = threadViewModel
        super.init(frame: .zero)
        
        // Blurred overlay
        // Default UIBlurEffect has a very heavy radius and it cannot be changed. For a lighter radius a custom solution is needed (not trivial).
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        self.addSubview(blurEffectView)
        blurEffectView.autoPinEdgesToSuperviewEdges()
        
        // Panel
        let panelView = UIView()
        panelView.backgroundColor = Theme.isDarkThemeEnabled ? UIColor.ows_gray700 : UIColor.ows_white
        panelView.layer.cornerRadius = 32.0
        self.addSubview(panelView)
        panelView.autoPinEdge(toSuperviewEdge: .leading, withInset: 10.0)
        panelView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 10.0)
        panelView.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 32.0)
        
        // StackView
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20.0
        panelView.addSubview(stackView)
        stackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 32.0, leading: 24.0, bottom: 24.0, trailing: 24.0))
        
        // Subscribe button
        let buttonHeight: CGFloat = 60
        let subscribeButton = UIButton()
        let text = NSLocalizedString("SUBSCRIPTION_PLAN_OVERLAY_SUBSCRIBE_BUTTON", comment: "Subscribe button text in SubscriptionPlanOverlayView.")
        subscribeButton.setTitle(text, for: .normal)
        subscribeButton.setTitleColor(UIColor.ows_white, for: .normal)
        subscribeButton.backgroundColor = UIColor.ows_azureRadianceDark500
        subscribeButton.addTarget(self, action: #selector(self.subscribeButtonPressed), for: .touchUpInside)
        subscribeButton.autoSetDimension(.height, toSize: buttonHeight)
        subscribeButton.layer.cornerRadius = buttonHeight / 2.0
        stackView.addArrangedSubview(subscribeButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    public func refreshView(withThreadViewModel threadViewModel: ThreadViewModel) {
        self.threadViewModel = threadViewModel
        
        self.updateVisibility()
    }
    
    // MARK: - Actions
    
    @objc func subscribeButtonPressed() {
        // TODO: Subscribe to current loop and refreshView
        OWSActionSheets.showActionSheet(title: NSLocalizedString("ALERT_ERROR_TITLE", comment: "Generic error indicator"),
                                        message: "To be implemented")
    }
    
    // MARK: - Private Methods
    
    private func updateVisibility() {
        guard nil != self.threadViewModel.subscriptionPlan else {
            self.isHidden = true
            return
        }
        
        if let subscription = self.threadViewModel.subscription {
            self.isHidden = (subscription.isActive && !subscription.hasIssue)
        } else {
            self.isHidden = false
        }
    }
}

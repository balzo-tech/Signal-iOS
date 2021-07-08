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
    
    private let optionView = SubscriptionPlanOverlayOptionView()
    
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
        
        // Group owner hint label
        let groupOwnerHintText = NSLocalizedString("SUBSCRIPTION_PLAN_OVERLAY_ADMIN", comment: "Loop admin hint in SubscriptionPlanOverlayView.")
        let groupOwnerHintLabel = UILabel()
        groupOwnerHintLabel.text = groupOwnerHintText
        groupOwnerHintLabel.textColor = Theme.isDarkThemeEnabled ? UIColor.ows_gray400 : UIColor.ows_gray500
        groupOwnerHintLabel.font = UIFont.ows_dynamicTypeCaption1
        stackView.addArrangedSubview(groupOwnerHintLabel)

        // Group owner view
        // TODO: Add group owner view

        // Subscription plan options hint label
        let subscriptionOptionsHintText = NSLocalizedString("SUBSCRIPTION_PLAN_OVERLAY_OPTIONS", comment: "Subscription options hint in SubscriptionPlanOverlayView.")
        let subscriptionOptionsHintLabel = UILabel()
        subscriptionOptionsHintLabel.text = subscriptionOptionsHintText
        subscriptionOptionsHintLabel.textColor = Theme.isDarkThemeEnabled ? UIColor.ows_gray400 : UIColor.ows_gray500
        subscriptionOptionsHintLabel.font = UIFont.ows_dynamicTypeCaption1
        stackView.addArrangedSubview(subscriptionOptionsHintLabel)

        // Subscription Plan view
        stackView.addArrangedSubview(self.optionView)

        // Tips
        let tipStackView = UIStackView()
        tipStackView.axis = .vertical
        tipStackView.spacing = 8
        stackView.addArrangedSubview(tipStackView)
        let tip1Text = NSLocalizedString("SUBSCRIPTION_PLAN_OVERLAY_TIP_1", comment: "Tip 1 in SubscriptionPlanOverlayView.")
        tipStackView.addSubscriptionTipView(text: tip1Text)
        let tip2Text = NSLocalizedString("SUBSCRIPTION_PLAN_OVERLAY_TIP_2", comment: "Tip 2 in SubscriptionPlanOverlayView.")
        tipStackView.addSubscriptionTipView(text: tip2Text)
        let tip3Text = NSLocalizedString("SUBSCRIPTION_PLAN_OVERLAY_TIP_3", comment: "Tip 3 in SubscriptionPlanOverlayView.")
        tipStackView.addSubscriptionTipView(text: tip3Text)

        // Subscribe button
        let buttonHeight: CGFloat = 60
        let subscribeButton = UIButton()
        let text = NSLocalizedString("SUBSCRIPTION_PLAN_OVERLAY_SUBSCRIBE_BUTTON", comment: "Subscribe button text in SubscriptionPlanOverlayView.")
        subscribeButton.setTitle(text, for: .normal)
        subscribeButton.setTitleColor(UIColor.ows_white, for: .normal)
        subscribeButton.titleLabel?.font = UIFont.ows_dynamicTypeTitle2
        subscribeButton.backgroundColor = UIColor.ows_azureRadianceDark500
        subscribeButton.addTarget(self, action: #selector(self.subscribeButtonPressed), for: .touchUpInside)
        subscribeButton.autoSetDimension(.height, toSize: buttonHeight)
        subscribeButton.layer.cornerRadius = buttonHeight / 2.0
        stackView.addArrangedSubview(subscribeButton)
        
        self.updateView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    public func refreshView(withThreadViewModel threadViewModel: ThreadViewModel) {
        self.threadViewModel = threadViewModel
        self.updateView()
    }
    
    // MARK: - Actions
    
    @objc func subscribeButtonPressed() {
        // TODO: Subscribe to current loop and refreshView
        OWSActionSheets.showActionSheet(title: NSLocalizedString("ALERT_ERROR_TITLE", comment: "Generic error indicator"),
                                        message: "To be implemented")
    }
    
    // MARK: - Private Methods
    
    private func updateView() {
        self.updateVisibility()
        if let subscriptionPlan = self.threadViewModel.subscriptionPlan {
            self.optionView.update(withSubscriptionPlan: subscriptionPlan)
        }
    }
    
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

fileprivate extension UIStackView {
    
    func addSubscriptionTipView(text: String) {
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 10.0
        
        let imageView = UIImageView(image: UIImage(named: "check-12")?.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = Theme.isDarkThemeEnabled ? UIColor.ows_persianGreenDark400 : UIColor.ows_persianGreenDark500
        imageView.contentMode = .scaleAspectFit
        imageView.autoSetDimension(.width, toSize: 12.0)
        horizontalStackView.addArrangedSubview(imageView)
        
        let label = UILabel()
        label.numberOfLines = 0
        label.text = text
        label.font = UIFont.ows_dynamicTypeSubheadline
        label.textColor = Theme.isDarkThemeEnabled ? UIColor.ows_gray400 : UIColor.ows_gray500
        horizontalStackView.addArrangedSubview(label)
        
        self.addArrangedSubview(horizontalStackView)
    }
}

fileprivate extension SubscriptionPlan {
    var descriptionText: String {
        return "\(self.period) \(self.periodUnitString.capitalizingFirstLetter())"
    }
    
    var priceText: String {
        // Euro currency is hardcoded for now... yes...
        return String(format: "%.02f €", self.price)
    }
    
    var renewDateText: String {
        guard let expiryDate = Calendar.current.date(byAdding: self.dateComponents, to: Date()) else {
            assertionFailure("Couldn't compute expiry date")
            return ""
        }
        let renewalDatePrefix = NSLocalizedString("SUBSCRIPTION_PLAN_OVERLAY_RENEW_DATE_PREFIX", comment: "Subscription renew date prefix in SubscriptionPlanOverlayView.")
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let renewDateString = dateFormatter.string(from: expiryDate)
        return renewalDatePrefix + " " + renewDateString
    }
}

class SubscriptionPlanOverlayOptionView: UIView {
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.ows_dynamicTypeCallout
        label.textColor = Theme.isDarkThemeEnabled ? UIColor.ows_white : UIColor.ows_gray800
        return label
    }()
    
    let renewDateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.ows_dynamicTypeCaption1
        label.textColor = Theme.isDarkThemeEnabled ? UIColor.ows_gray500 : UIColor.ows_gray400
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.ows_dynamicTypeCallout
        label.textColor = Theme.isDarkThemeEnabled ? UIColor.ows_white : UIColor.ows_gray800
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        let outerHorizontalStackView = UIStackView()
        outerHorizontalStackView.axis = .horizontal
        outerHorizontalStackView.spacing = 10.0
        self.addSubview(outerHorizontalStackView)
        outerHorizontalStackView.autoPinEdgesToSuperviewEdges()
        
        let innerVerticalStackView = UIStackView()
        innerVerticalStackView.axis = .vertical
        innerVerticalStackView.spacing = 4
        outerHorizontalStackView.addArrangedSubview(innerVerticalStackView)
        innerVerticalStackView.addArrangedSubview(self.descriptionLabel)
        innerVerticalStackView.addArrangedSubview(self.renewDateLabel)
        
        self.priceLabel.setContentHuggingHorizontalHigh()
        self.priceLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        outerHorizontalStackView.addArrangedSubview(self.priceLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    public func update(withSubscriptionPlan subscriptionPlan: SubscriptionPlan) {
        self.descriptionLabel.text = subscriptionPlan.descriptionText
        self.renewDateLabel.text = subscriptionPlan.renewDateText
        self.priceLabel.text = subscriptionPlan.priceText
    }
}

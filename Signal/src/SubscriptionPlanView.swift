//
//  Copyright (c) 2021 Attimo Srl. All rights reserved.
//

import Foundation

class SubscriptionPlanView: UIView {
    
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
        self.renewDateLabel.text = subscriptionPlan.getRenewDateText(withExpiryDate: nil)
        self.priceLabel.text = subscriptionPlan.priceText
    }
    
    public func update(withSubscription subscription: Subscription) {
        self.descriptionLabel.text = subscription.subscriptionPlan.descriptionText
        self.renewDateLabel.text = subscription.subscriptionPlan.getRenewDateText(withExpiryDate: subscription.expirationDate)
        self.priceLabel.text = subscription.subscriptionPlan.priceText
    }
}

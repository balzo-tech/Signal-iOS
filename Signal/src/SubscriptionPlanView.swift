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
    
    public func update(withSubscriptionPlan subscriptionPlan: SubscriptionPlan, expirationDate: Date? = nil) {
        self.descriptionLabel.text = subscriptionPlan.descriptionText
        self.renewDateLabel.text = subscriptionPlan.getRenewDateText(withExpiryDate: expirationDate)
        self.priceLabel.text = subscriptionPlan.priceText
    }
}

fileprivate extension SubscriptionPlan {
    var descriptionText: String {
        return "\(self.period) \(self.periodUnitString.capitalizingFirstLetter())"
    }
    
    var priceText: String {
        // Euro currency is hardcoded for now... yes...
        return String(format: "%.02f€", self.price)
    }
    
    /// If no expiry date is provided, it would be calculated as if the subscription started today
    func getRenewDateText(withExpiryDate expiryDate: Date?) -> String {
        let unwrappedExpiryDate: Date
        if let expiryDate = expiryDate {
            unwrappedExpiryDate = expiryDate
        } else {
            guard let expiryDate = Calendar.current.date(byAdding: self.dateComponents, to: Date()) else {
                assertionFailure("Couldn't compute expiry date")
                return ""
            }
            unwrappedExpiryDate = expiryDate
        }
        
        let renewalDatePrefix = NSLocalizedString("SUBSCRIPTION_PLAN_OVERLAY_RENEW_DATE_PREFIX", comment: "Subscription renew date prefix in SubscriptionPlanOverlayView.")
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let renewDateString = dateFormatter.string(from: unwrappedExpiryDate)
        return renewalDatePrefix + " " + renewDateString
    }
}

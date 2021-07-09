//
//  Copyright (c) 2020 Open Whisper Systems. All rights reserved.
//

import Foundation

extension SubscriptionPlan {
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
        
        let renewalDatePrefix = NSLocalizedString("SUBSCRIPTION_PLAN_RENEW_DATE_PREFIX", comment: "Subscription renew date prefix.")
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let renewDateString = dateFormatter.string(from: unwrappedExpiryDate)
        return renewalDatePrefix + " " + renewDateString
    }
}

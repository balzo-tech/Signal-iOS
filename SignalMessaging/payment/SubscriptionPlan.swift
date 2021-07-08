//
//  Copyright (c) 2021 Attimo Srl. All rights reserved.
//

import Foundation

@objc
public class SubscriptionPlan: NSObject {
    @objc public enum PeriodUnit: Int {
        case day, week, month, year
    }
    
    @objc public let price: Float
    @objc public let period: Int
    @objc public let periodUnit: PeriodUnit
    
    @objc public init(price: Float, period: Int, periodUnit: PeriodUnit) {
        self.price = price
        self.period = period
        self.periodUnit = periodUnit
    }
}

public extension SubscriptionPlan {
    var dateComponents: DateComponents {
        switch self.periodUnit {
        case .day: return DateComponents(day: self.period)
        case .week: return DateComponents(day: self.period * 7)
        case .month: return DateComponents(month: self.period)
        case .year: return DateComponents(year: self.period)
        }
    }
    
    var periodUnitString: String {
        switch self.periodUnit {
        case .day:
            return ((self.period == 1)
                        ? NSLocalizedString("SUBSCRIPTION_PLAN_DURATION_DAY_SINGLE", comment: "Subscription plan period unit day singular.")
                        : NSLocalizedString("SUBSCRIPTION_PLAN_DURATION_DAY_MULTIPLE", comment: "Subscription plan period unit day plural."))
        case .week:
            return ((self.period == 1)
                        ? NSLocalizedString("SUBSCRIPTION_PLAN_DURATION_WEEK_SINGLE", comment: "Subscription plan period unit week singular.")
                        : NSLocalizedString("SUBSCRIPTION_PLAN_DURATION_WEEK_MULTIPLE", comment: "Subscription plan period unit week plural."))
        case .month:
            return ((self.period == 1)
                        ? NSLocalizedString("SUBSCRIPTION_PLAN_DURATION_MONTH_SINGLE", comment: "Subscription plan period unit month singular.")
                        : NSLocalizedString("SUBSCRIPTION_PLAN_DURATION_MONTH_MULTIPLE", comment: "Subscription plan period unit month plural."))
        case .year:
            return ((self.period == 1)
                        ? NSLocalizedString("SUBSCRIPTION_PLAN_DURATION_YEAR_SINGLE", comment: "Subscription plan period unit year singular.")
                        : NSLocalizedString("SUBSCRIPTION_PLAN_DURATION_YEAR_MULTIPLE", comment: "Subscription plan period unit year plural."))
        }
    }
}

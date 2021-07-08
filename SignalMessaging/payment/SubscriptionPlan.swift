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
}

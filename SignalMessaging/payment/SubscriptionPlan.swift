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

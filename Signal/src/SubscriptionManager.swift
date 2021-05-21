//
//  Copyright (c) 2021 Attimo Srl. All rights reserved.
//

import Foundation

@objc
class SubscriptionManager: NSObject {
    
    private let paymentManager: PaymentManager
    
    @objc
    public init(withPaymentManager paymentManager: PaymentManager) {
        self.paymentManager = paymentManager
        super.init()
        
        SwiftSingletons.register(self)
    }
}

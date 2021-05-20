//
//  Copyright (c) 2021 Attimo Srl. All rights reserved.
//

import Foundation
import Stripe

@objc
class SubscriptionManager: NSObject {
    
    @objc
    public override init() {
        super.init()

        SwiftSingletons.register(self)
    }
}

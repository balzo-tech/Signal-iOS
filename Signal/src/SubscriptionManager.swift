//
//  Copyright (c) 2021 Attimo Srl. All rights reserved.
//

import Foundation
import PromiseKit

@objc
class SubscriptionManager: NSObject {
    
    private let paymentManager: PaymentManager
    private let paymentNetworkService: PaymentNetworkService
    
    public init(withPaymentManager paymentManager: PaymentManager, paymentNetworkService: PaymentNetworkService) {
        self.paymentManager = paymentManager
        self.paymentNetworkService = paymentNetworkService
        super.init()
        
        SwiftSingletons.register(self)
    }
    
    func checkIfCanAddSubscriptionPlans() -> Promise<Bool> {
        return self.paymentNetworkService.checkIfCanAddSubscriptionPlans()
    }
    
    func checkIfCanViewGroup(_ group: TSGroupThread) -> Promise<Bool> {
        return self.paymentNetworkService.checkIfCanViewGroup(group)
    }
    
    func updateSubscriptionPlan(toGroup group: TSGroupThread, subscriptionPlan: SubscriptionPlan) -> Promise<Void> {
        return self.paymentNetworkService.updateSubscriptionPlan(toGroup: group, subscriptionPlan: subscriptionPlan)
    }
    
    func getSubscriptionPlan(forGroup group: TSGroupThread) -> Promise<SubscriptionPlan?> {
        return self.paymentNetworkService.getSubscriptionPlan(forGroup: group)
    }
    
    func subscribe(toGroup group: TSGroupThread) -> Promise<Void> {
        return self.paymentNetworkService.subscribe(toGroup: group)
    }
    
    func unsubscribe(fromGroup group: TSGroupThread) -> Promise<Void> {
        return self.paymentNetworkService.unsubscribe(fromGroup: group)
    }
    
    func getSubscriptionList() -> Promise<[Subscription]> {
        return self.paymentNetworkService.getSubscriptionList()
    }
}

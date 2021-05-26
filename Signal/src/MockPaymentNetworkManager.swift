//
//  Copyright (c) 2020 Open Whisper Systems. All rights reserved.
//

import Foundation
import PromiseKit

class MockPaymentNetworkManager: NSObject {
    
    private static let defaultNetworkCallDelayTime: TimeInterval = 0.5
    
    //
    // ---- Mock Data
    //
    
    // User has already registered on Stripe Connect
    private static let canAddSubscriptionPlans: Bool = true
    
    private static let canAccessAllPremiumGroups: Bool = true
    
    private static let currentSubscriptions: [Subscription] = [
        Subscription(identifier: "1", groupName: "Test Premium Group 1"),
        Subscription(identifier: "2", groupName: "Test Premium Group 2"),
        Subscription(identifier: "3", groupName: "Test Premium Group 3"),
        Subscription(identifier: "4", groupName: "Test Premium Group 4"),
    ]
    
    private static let subscriptionPlanForAllGroups: SubscriptionPlan? = {
        return SubscriptionPlan(price: 9.99, period: 1, periodUnit: .month)
    }()
    
    private var defaultRequestDelay: Guarantee<Void> {
        return after(seconds: Self.defaultNetworkCallDelayTime)
    }
    
    override init() {
        super.init()

        SwiftSingletons.register(self)
    }
}

extension MockPaymentNetworkManager: PaymentNetworkService {
    
    // Needed by Stripe for customer authentication
    func createCustomerKey(withAPIVersion apiVersion: String) -> Promise<[AnyHashable: Any]?> {
        return self.defaultRequestDelay.map { throw PaymentNetworkError.invalidResponse }
    }
    
    func checkIfCanAddSubscriptionPlans() -> Promise<Bool> {
        return self.defaultRequestDelay.map { Self.canAddSubscriptionPlans }
    }
    
    func checkIfCanViewGroup(_ group: TSGroupThread) -> Promise<Bool> {
        return self.defaultRequestDelay.map { Self.canAccessAllPremiumGroups }
    }
    
    func updateSubscriptionPlan(toGroup group: TSGroupThread, subscriptionPlan: SubscriptionPlan) -> Promise<Void> {
        return self.defaultRequestDelay.asVoid()
    }
    
    func getSubscriptionPlan(forGroup group: TSGroupThread) -> Promise<SubscriptionPlan?> {
        return self.defaultRequestDelay.map { Self.subscriptionPlanForAllGroups }
    }
    
    func subscribe(toGroup group: TSGroupThread) -> Promise<Void> {
        return self.defaultRequestDelay.asVoid()
    }
    
    func unsubscribe(fromGroup group: TSGroupThread) -> Promise<Void> {
        return self.defaultRequestDelay.asVoid()
    }
    
    func getSubscriptionList() -> Promise<[Subscription]> {
        return self.defaultRequestDelay.map { Self.currentSubscriptions }
    }
}

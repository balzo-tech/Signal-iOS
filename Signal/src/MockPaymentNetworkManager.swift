//
//  Copyright (c) 2021 Attimo Srl. All rights reserved.
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
        Subscription(identifier: "1",
                     hasIssue: true,
                     isActive: true,
                     expirationDate: Date(timeIntervalSinceNow: -24 * 60 * 60),
                     subscriptionPlan: SubscriptionPlan(price: 9.99, period: 1, periodUnit: .month)),
        Subscription(identifier: "2",
                     hasIssue: false,
                     isActive: true,
                     expirationDate: Date(timeIntervalSinceNow: 2 * 24 * 60 * 60),
                     subscriptionPlan: SubscriptionPlan(price: 9.99, period: 1, periodUnit: .month)),
        Subscription(identifier: "3",
                     hasIssue: false,
                     isActive: true,
                     expirationDate: Date(timeIntervalSinceNow: 3 * 24 * 60 * 60),
                     subscriptionPlan: SubscriptionPlan(price: 9.99, period: 1, periodUnit: .month)),
        Subscription(identifier: "4",
                     hasIssue: false,
                     isActive: true,
                     expirationDate: Date(timeIntervalSinceNow: 4 * 24 * 60 * 60),
                     subscriptionPlan: SubscriptionPlan(price: 9.99, period: 1, periodUnit: .month)),
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
    
    private static var testStripeBaseUrl: URL { URL(string: "https://loop-test-balzo.herokuapp.com")! }
    
    // Needed by Stripe for customer authentication
    func createCustomerKey(withAPIVersion apiVersion: String) -> Promise<[AnyHashable: Any]?> {
        return Promise { seal in
            let url = Self.testStripeBaseUrl.appendingPathComponent("ephemeral_keys")
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            urlComponents.queryItems = [URLQueryItem(name: "api_version", value: apiVersion)]
            var request = URLRequest(url: urlComponents.url!)
            request.httpMethod = "POST"
            let task = URLSession.shared.dataTask(
                with: request,
                completionHandler: { (data, response, error) in
                    guard let response = response as? HTTPURLResponse,
                        response.statusCode == 200,
                        let data = data,
                        let json =
                            ((try? JSONSerialization.jsonObject(with: data, options: [])
                            as? [String: Any]) as [String: Any]??)
                    else {
                        seal.resolve(nil, error)
                        return
                    }
                    seal.resolve(json, nil)
                })
            task.resume()
        }
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

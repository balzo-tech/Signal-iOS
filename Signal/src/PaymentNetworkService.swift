//
//  Copyright (c) 2021 Attimo Srl. All rights reserved.
//

import Foundation
import PromiseKit
import SignalServiceKit

enum PaymentNetworkError: LocalizedError {
    case invalidResponse
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse: return NSLocalizedString("ERROR_DESCRIPTION_SERVER_FAILURE", comment: "Generic server error")
        }
    }
}

protocol PaymentNetworkService: NSObject {
    // Needed by Stripe for customer authentication
    func createCustomerKey(withAPIVersion apiVersion: String) -> Promise<[AnyHashable: Any]?>
    
    func checkIfCanAddSubscriptionPlans() -> Promise<Bool>
    func checkIfCanViewGroup(_ group: TSGroupThread) -> Promise<Bool>
    func updateSubscriptionPlan(toGroup group: TSGroupThread, subscriptionPlan: SubscriptionPlan) -> Promise<Void>
    func getSubscriptionPlan(forGroup group: TSGroupThread) -> Promise<SubscriptionPlan?>
    func subscribe(toGroup group: TSGroupThread) -> Promise<Void>
    func unsubscribe(fromGroup group: TSGroupThread) -> Promise<Void>
    func getSubscriptionList() -> Promise<[Subscription]>
}

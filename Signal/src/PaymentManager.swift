//
//  Copyright (c) 2021 Attimo Srl. All rights reserved.
//

import Foundation
import UIKit
import Stripe
import PromiseKit

class PaymentManager: NSObject {
    
    static private let theme: STPTheme = {
        // TODO: Add custom theme
        return .defaultTheme
    }()
    
    private let paymentConfiguration: STPPaymentConfiguration = {
        let config = STPPaymentConfiguration()
        config.requiredShippingAddressFields = [.emailAddress]
        config.requiredBillingAddressFields = .none
        config.appleMerchantIdentifier = "merchant.com.join.loop"
        return config
    }()
    
    private lazy var customerContext: STPCustomerContext = {
        let context = STPCustomerContext(keyProvider: self)
        context.includeApplePayPaymentMethods = true
        return context
    }()
    
    private let paymentNetworkService: PaymentNetworkService
    
    init(paymentNetworkService: PaymentNetworkService) {
        self.paymentNetworkService = paymentNetworkService
        super.init()

        SwiftSingletons.register(self)
        
        StripeAPI.defaultPublishableKey = FeatureFlags.isUsingProductionService ? ProjectInfo.StripeTestKey : ProjectInfo.StripeProductionKey
    }
    
    func showPaymentMethods(presenter: UIViewController) -> PromiseKit.Promise<Void> {
        let delegateProxy = STPPaymentOptionsViewControllerProxy()
        let viewController = STPPaymentOptionsViewController(configuration: self.paymentConfiguration,
                                                             theme: Self.theme,
                                                             customerContext: self.customerContext,
                                                             delegate: delegateProxy)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.stp_theme = Self.theme
        // Ensure that the view controller is dismissed only through STPPaymentOptionsViewControllerDelegate delegate methods,
        // thus allowing the proxy to be released from memory.
        navigationController.modalPresentationStyle = .fullScreen
        presenter.present(navigationController, animated: true, completion: nil)
        return delegateProxy.promise
    }
    
    func checkIfDefaultPaymentMethodExist() -> PromiseKit.Promise<Bool> {
        return Promise { self.customerContext.retrieveCustomer($0.resolve) }.map { !$0.sources.isEmpty }
    }
    
    func onLogOut() {
        self.customerContext.clearCache()
    }
}

fileprivate class STPPaymentOptionsViewControllerProxy: NSObject, STPPaymentOptionsViewControllerDelegate {
    var (promise, seal) = PromiseKit.Promise<Void>.pending()
    private var retainCycle: STPPaymentOptionsViewControllerProxy?
    
    override init() {
        super.init()
        self.retainCycle = self
        
        self.promise = self.promise.ensure {
            // ensure we break the retain cycle
            self.retainCycle = nil
        }
    }
    
    func paymentOptionsViewController(_ paymentOptionsViewController: STPPaymentOptionsViewController,didFailToLoadWithError error: Error) {
        paymentOptionsViewController.dismiss(animated: true, completion: { self.seal.reject(error) })
    }
    
    func paymentOptionsViewControllerDidFinish(_ paymentOptionsViewController: STPPaymentOptionsViewController) {
        paymentOptionsViewController.dismiss(animated: true, completion: { self.seal.fulfill(()) })
    }
    
    func paymentOptionsViewControllerDidCancel(_ paymentOptionsViewController: STPPaymentOptionsViewController) {
        paymentOptionsViewController.dismiss(animated: true, completion: { self.seal.fulfill(()) })
    }
}

extension PaymentManager: STPCustomerEphemeralKeyProvider {
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        firstly {
            self.paymentNetworkService.createCustomerKey(withAPIVersion: apiVersion)
        }.done { customerKey in
            completion(customerKey, nil)
        }.catch { error in
            completion(nil, error)
        }
    }
}

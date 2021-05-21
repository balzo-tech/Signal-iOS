//
//  Copyright (c) 2021 Attimo Srl. All rights reserved.
//

import Foundation
import UIKit
import Stripe

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
//        let context = STPCustomerContext(keyProvider: self)
        
        // Mock customer context to show the payment methods UI, waiting for the backend to provide the ephemeral key.
        let keyManager = STPEphemeralKeyManager(
            keyProvider: MockKeyProvider(),
            apiVersion: STPAPIClient.apiVersion,
            performsEagerFetching: true)
        let context = MockCustomerContext(keyManager: keyManager, apiClient: MockAPIClient())
        
        context.includeApplePayPaymentMethods = true
        return context
    }()
    
    override init() {
        super.init()

        SwiftSingletons.register(self)
        
        StripeAPI.defaultPublishableKey = FeatureFlags.isUsingProductionService ? ProjectInfo.StripeTestKey : ProjectInfo.StripeProductionKey
    }
    
    func showPaymentMethods(presenter: UIViewController) {
        let viewController = STPPaymentOptionsViewController(configuration: self.paymentConfiguration,
                                                             theme: Self.theme,
                                                             customerContext: self.customerContext,
                                                             delegate: self)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.stp_theme = Self.theme
        presenter.present(navigationController, animated: true, completion: nil)
    }
    
    func onLogOut() {
        self.customerContext.clearCache()
    }
}

extension PaymentManager: STPPaymentOptionsViewControllerDelegate {
    
    func paymentOptionsViewController(_ paymentOptionsViewController: STPPaymentOptionsViewController,didFailToLoadWithError error: Error) {
        print("PaymentManager - paymentOptionsViewController")
        OWSActionSheets.showActionSheet(title: NSLocalizedString("ERROR_NETWORK_FAILURE",
                                                                 comment: "Error indicating network connectivity problems."),
                                        message: error.localizedDescription)
    }
    
    func paymentOptionsViewControllerDidFinish(_ paymentOptionsViewController: STPPaymentOptionsViewController) {
        print("PaymentManager - paymentOptionsViewControllerDidFinish")
        paymentOptionsViewController.dismiss(animated: true, completion: nil)
    }
    
    func paymentOptionsViewControllerDidCancel(_ paymentOptionsViewController: STPPaymentOptionsViewController) {
        print("PaymentManager - paymentOptionsViewControllerDidCancel")
        paymentOptionsViewController.dismiss(animated: true, completion: nil)
    }
}

extension PaymentManager: STPCustomerEphemeralKeyProvider {
    
    enum CustomerKeyError: Error {
        case invalidResponse
    }

    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        // TODO: Call specific backend endpoint to get the Stripe Customer Ephemeral Key for the current user
        completion(nil, CustomerKeyError.invalidResponse)
    }
}




// The following code has the only purpose of testing the payment method options UI.
// TODO: Remove all of this as soon as the backend provides an endpoint to get the ephemeral key

import Foundation

@testable import Stripe

class MockCustomer: STPCustomer {
    var mockPaymentMethods: [STPPaymentMethod] = []
    var mockDefaultPaymentMethod: STPPaymentMethod?
    var mockShippingAddress: STPAddress?

    init() {
        super.init(
            stripeID: "", defaultSource: nil, sources: [], shippingAddress: nil,
            allResponseFields: [:])
        /**
         Preload the mock customer with saved cards.
         last4 values are from test cards: https://stripe.com/docs/testing#cards
         Not using the "4242" and "4444" numbers, since those are the easiest
         to remember and fill.
        */
        let visa =
            [
                "card": [
                    "id": "preloaded_visa",
                    "exp_month": "10",
                    "exp_year": "2020",
                    "last4": "1881",
                    "brand": "visa",
                ],
                "type": "card",
                "id": "preloaded_visa",
            ] as [String: Any]
        if let card = STPPaymentMethod.decodedObject(fromAPIResponse: visa) {
            mockPaymentMethods.append(card)
        }
        let masterCard =
            [
                "card": [
                    "id": "preloaded_mastercard",
                    "exp_month": "10",
                    "exp_year": "2020",
                    "last4": "8210",
                    "brand": "mastercard",
                ],
                "type": "card",
                "id": "preloaded_mastercard",
            ] as [String: Any]
        if let card = STPPaymentMethod.decodedObject(fromAPIResponse: masterCard) {
            mockPaymentMethods.append(card)
        }
        let amex =
            [
                "card": [
                    "id": "preloaded_amex",
                    "exp_month": "10",
                    "exp_year": "2020",
                    "last4": "0005",
                    "brand": "amex",
                ],
                "type": "card",
                "id": "preloaded_amex",
            ] as [String: Any]
        if let card = STPPaymentMethod.decodedObject(fromAPIResponse: amex) {
            mockPaymentMethods.append(card)
        }
    }

    var paymentMethods: [STPPaymentMethod] {
        get {
            return mockPaymentMethods
        }
        set {
            mockPaymentMethods = newValue
        }
    }

    var defaultPaymentMethod: STPPaymentMethod? {
        get {
            return mockDefaultPaymentMethod
        }
        set {
            mockDefaultPaymentMethod = newValue
        }
    }

    override var shippingAddress: STPAddress? {
        get {
            return mockShippingAddress
        }
        set {
            mockShippingAddress = newValue
        }
    }
}

class MockKeyProvider: NSObject, STPCustomerEphemeralKeyProvider {
    func createCustomerKey(
        withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock
    ) {
        completion(nil, NSError.stp_ephemeralKeyDecodingError())
    }
}

class MockCustomerContext: STPCustomerContext {

    let customer = MockCustomer()

    override func retrieveCustomer(_ completion: STPCustomerCompletionBlock? = nil) {
        if let completion = completion {
            completion(customer, nil)
        }
    }

    override func attachPaymentMethod(
        toCustomer paymentMethod: STPPaymentMethod, completion: STPErrorBlock? = nil
    ) {
        customer.paymentMethods.append(paymentMethod)
        if let completion = completion {
            completion(nil)
        }
    }

    override func detachPaymentMethod(
        fromCustomer paymentMethod: STPPaymentMethod, completion: STPErrorBlock? = nil
    ) {
        if let index = customer.paymentMethods.firstIndex(where: {
            $0.stripeId == paymentMethod.stripeId
        }) {
            customer.paymentMethods.remove(at: index)
        }
        if let completion = completion {
            completion(nil)
        }
    }

    override func listPaymentMethodsForCustomer(completion: STPPaymentMethodsCompletionBlock? = nil)
    {
        if let completion = completion {
            completion(customer.paymentMethods, nil)
        }
    }

    func selectDefaultCustomerPaymentMethod(
        _ paymentMethod: STPPaymentMethod, completion: @escaping STPErrorBlock
    ) {
        if customer.paymentMethods.contains(where: { $0.stripeId == paymentMethod.stripeId }) {
            customer.defaultPaymentMethod = paymentMethod
        }
        completion(nil)
    }

    override func updateCustomer(
        withShippingAddress shipping: STPAddress, completion: STPErrorBlock?
    ) {
        customer.shippingAddress = shipping
        if let completion = completion {
            completion(nil)
        }
    }

    override func retrieveLastSelectedPaymentMethodIDForCustomer(
        completion: @escaping (String?, Error?) -> Void
    ) {
        completion(nil, nil)
    }
    override func saveLastSelectedPaymentMethodID(
        forCustomer paymentMethodID: String?, completion: STPErrorBlock?
    ) {
        if let completion = completion {
            completion(nil)
        }
    }
}

class MockAPIClient: STPAPIClient {
    override func createPaymentMethod(
        with paymentMethodParams: STPPaymentMethodParams,
        completion: @escaping STPPaymentMethodCompletionBlock
    ) {
        guard let card = paymentMethodParams.card,
            let billingDetails = paymentMethodParams.billingDetails
        else { return }

        // Generate a mock card model using the given card params
        var cardJSON: [String: Any] = [:]
        var billingDetailsJSON: [String: Any] = [:]
        cardJSON["id"] = "\(card.hashValue)"
        cardJSON["exp_month"] = "\(card.expMonth ?? 0)"
        cardJSON["exp_year"] = "\(card.expYear ?? 0)"
        cardJSON["last4"] = card.number?.suffix(4)
        billingDetailsJSON["name"] = billingDetails.name
        billingDetailsJSON["line1"] = billingDetails.address?.line1
        billingDetailsJSON["line2"] = billingDetails.address?.line2
        billingDetailsJSON["state"] = billingDetails.address?.state
        billingDetailsJSON["postal_code"] = billingDetails.address?.postalCode
        billingDetailsJSON["country"] = billingDetails.address?.country
        cardJSON["country"] = billingDetails.address?.country
        if let number = card.number {
            let brand = STPCardValidator.brand(forNumber: number)
            cardJSON["brand"] = STPCard.string(from: brand)
        }
        cardJSON["fingerprint"] = "\(card.hashValue)"
        cardJSON["country"] = "US"
        let paymentMethodJSON: [String: Any] = [
            "id": "\(card.hashValue)",
            "object": "payment_method",
            "type": "card",
            "livemode": false,
            "created": NSDate().timeIntervalSince1970,
            "used": false,
            "card": cardJSON,
            "billing_details": billingDetailsJSON,
        ]
        let paymentMethod = STPPaymentMethod.decodedObject(fromAPIResponse: paymentMethodJSON)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            completion(paymentMethod, nil)
        }
    }
}

//
//  Copyright (c) 2021 Attimo Srl. All rights reserved.
//

import Foundation

@objc
public class Subscription: NSObject {
    @objc public let identifier: String
    @objc public let hasIssue: Bool
    @objc public let isActive: Bool
    @objc public let expirationDate: Date
    
    @objc public init(identifier: String, hasIssue: Bool, isActive: Bool, expirationDate: Date) {
        self.identifier = identifier
        self.hasIssue = hasIssue
        self.isActive = isActive
        self.expirationDate = expirationDate
    }
}

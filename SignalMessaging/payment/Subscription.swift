//
//  Copyright (c) 2021 Attimo Srl. All rights reserved.
//

import Foundation

@objc
public class Subscription: NSObject {
    @objc public let identifier: String
    @objc public let hasIssue: Bool
    
    @objc public init(identifier: String, hasIssue: Bool) {
        self.identifier = identifier
        self.hasIssue = hasIssue
    }
}

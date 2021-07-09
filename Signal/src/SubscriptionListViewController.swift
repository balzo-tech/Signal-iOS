//
//  Copyright (c) 2021 Attimo Srl. All rights reserved.
//

import Foundation
import UIKit

class SubscriptionListViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.title = NSLocalizedString("SUBSCRIPTION_LIST_TITLE", comment: "Title of SubscriptionListViewController.")
        self.view.backgroundColor = Theme.backgroundColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

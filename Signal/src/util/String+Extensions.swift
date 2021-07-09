//
//  Copyright (c) 2021 Attimo Srl. All rights reserved.
//

import Foundation

extension String {
    public func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}

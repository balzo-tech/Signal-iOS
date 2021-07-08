//
//  Copyright (c) 2020 Open Whisper Systems. All rights reserved.
//

import Foundation

extension String {
    public func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}

//
//  String.swift
//  MR007
//
//  Created by Roger Molas on 08/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

extension String {

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }

    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }

    subscript (iii: Int) -> Character {
        return self[index(startIndex, offsetBy: iii)]
    }

    subscript (iii: Int) -> String {
        return String(self[iii] as Character)
    }

    subscript (rrr: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: rrr.lowerBound)
        let end = index(startIndex, offsetBy: rrr.upperBound)
        return self[Range(start ..< end)]
    }
}

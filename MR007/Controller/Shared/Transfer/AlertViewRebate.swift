//
//  AlertViewRebate.swift
//  MR007
//
//  Created by Roger Molas on 14/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

class AlertViewRebate: UIAlertController {
    let alertMessage = AlertMessage()

    func setUpView() {
        self.view.tintColor = Alert.globalTint
        let rebate = UIAlertAction(title: alertMessage.carryOut, style: .default, handler: nil)
        self.addAction(rebate)
    }
}

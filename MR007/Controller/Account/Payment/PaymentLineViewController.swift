//
//  PaymentLineViewController.swift
//  MR007
//
//  Created by GreatFeat on 16/05/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit
import Crashlytics

let wechatColor = UIColor(colorLiteralRed: 140.0/255, green: 208.0/255, blue: 151.0/255, alpha: 1.0)
let aliPayColor = UIColor(colorLiteralRed: 0.0/255, green: 170.0/255, blue: 244.0/255, alpha: 1.0)
let qqPayColor = UIColor(colorLiteralRed: 11.0/255, green: 125.0/255, blue: 177.0/255, alpha: 1.0)

class PaymentLineViewController: BaseViewController {
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var amountField: UITextField!

    var htmlString = String()
    var payment = String()
    var currentMethod: GateWayModel? = nil
    var gatewayCategory = String()
    var gateWayId = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        amountField.becomeFirstResponder()
        if payment == "wechat" {
            self.confirmButton.backgroundColor = wechatColor
        }
        if payment == "alipay" {
            self.confirmButton.backgroundColor = aliPayColor
        }
        if payment == "qq" {
            self.confirmButton.backgroundColor = aliPayColor
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? DepositOnlineWebViewController {
            viewController.htmlString = self.htmlString
        }
    }

    @IBAction func submitDeposit() {
        if (self.amountField.text?.characters.count)! > 0 {
            self.sendDepositToPaymentGateway()
        }
    }

    /// Send deposit request to third party
    func sendDepositToPaymentGateway() {
        LoadingView.nativeProgress()
        let request = DepositRequestManager()
        request.sendDepositToGateways(completionHandler: { (response) in
            LoadingView.hide()

            let user = SharedUserInfo.sharedInstance
            Answers.logCustomEvent(withName: "Deposit", customAttributes: [ "user": user.getUserName(), "gateway": self.gatewayCategory, "gateWayId": self.gateWayId, "amount": self.amountField.text!, "response": response ])

            self.htmlString = response
            self.performSegue(withIdentifier: "segueToWeb", sender: self)
        }, errorHandler: { (error) in
            LoadingView.hide()
            Alert.with(title: self.alertMessage.error, message: error.localizedDescription)
        }, category: self.gatewayCategory, amount: amountField.text!, id: gateWayId)
    }
}

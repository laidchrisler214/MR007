//
//  PaymentOnlineViewController.swift
//  MR007
//
//  Created by GreatFeat on 17/05/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

class PaymentOnlineViewController: UIViewController {
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var amountLabel: AmountLabel!
    @IBOutlet weak var keypadView: UIView!

    var currentMethod: DepositMethodModel? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        let keypad = KeypadView.loadView()
        keypad.set(inputView: &self.amountLabel)
        self.amountLabel.isUserInteractionEnabled = true
        self.keypadView.addSubview(keypad)
        keypad.frame = self.keypadView.frame
        keypad.center.x = self.keypadView.frame.size.width / 2
        keypad.center.y = self.keypadView.frame.size.height / 2
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    @IBAction func viewDebitCards() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let debitCardView = storyboard.instantiateViewController(withIdentifier: StoryboardId.debitCard) as? DebitCardViewController
//        debitCardView?.delegate = self
//        self.present(debitCardView!, animated: false)
    }

    @IBAction func submitDeposit() {
//        if (self.amountLabel.text?.characters.count)! > 0 {
//            self.sendDepositToPaymentGateway()
//        }
    }

    /// Send deposit request to third party
//    func sendDepositToPaymentGateway() {
//        let request = DepositRequestManager()
//        request.sendDepositToGateway(completionHandler: { (user, details) in
//            let storyboard = UIStoryboard(name: StoryboardId.main, bundle: nil)
//            let webviewVC = storyboard.instantiateViewController(withIdentifier: StoryboardId.webView) as? WebViewController
//            webviewVC?.urlString = details!
//            webviewVC?.titleString = "Payment"
//            webviewVC?.isPresented = true
//
//            // Add navigation controller
//            let navigation = UINavigationController(rootViewController: webviewVC!)
//            navigation.navigationBar.barTintColor = UIColor(red: 27/225, green: 95/225, blue: 124/225, alpha: 1.0)
//            navigation.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
//            self.present(navigation, animated: true, completion: nil)
//            self.amountLabel.text = "Amount"
//
//        }, error: { (error) in
//
//        }, params: self.getParamGateway())
//    }

//    func getParamGateway() -> NSDictionary {
//        let param = NSDictionary(dictionaryLiteral: ("category", self.currentMethod?.category ?? ""),
//                                 ("amount", self.amountLabel.text ?? ""),
//                                 ("id", self.currentMethod?.methodId ?? ""))
//        return param
//    }
}

//extension PaymentOnlineViewController: DebitCardViewDelegate {
//    func didAddDebitCardRequest() {
//        self.performSegue(withIdentifier: Segue.addDebitCard, sender: nil)
//    }
//
//    func didSelectBank(bank: WithdrawalBankModel) {
//        print("TODO API")
//    }
//}

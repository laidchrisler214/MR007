//
//  AddDebitCardViewController.swift
//  MR007
//
//  Created by GreatFeat on 19/05/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

class AddDebitCardViewController: BaseViewController {

    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var bankName: UITextField!
    @IBOutlet weak var accountNumberField: UITextField!
    @IBOutlet weak var bankBranch: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUserName()
    }

    @IBAction func addBankAction(_ sender: Any) {
        if fieldsAreValid() {
            let request = WithdrawalRequestManager()
            let params = ["accountName": accountNameLabel.text!, "bankName": bankName.text!, "bankAccount": accountNumberField.text!, "bankBranch": bankBranch.text!] as NSDictionary
            LoadingView.nativeProgress()
            request.requestAdd(completionHandler: { (user, message) in
                LoadingView.hide()
                DispatchQueue.main.async {
                    self.performSegueToReturnBack()
                }
            }, error: { (error) in
                LoadingView.hide()
            }, params: params)
        } else {
            Alert.with(title: alertMessage.error, message: alertMessage.missingInfo)
        }
    }

    //MARK: HELPER
    func setUserName() {
        let sharedUser = SharedUserInfo.sharedInstance
        self.accountNameLabel.text = "收款人：\(sharedUser.getUserName())"
    }

    func fieldsAreValid() -> Bool {
        if (bankName.text?.isEmpty)! || (accountNumberField.text?.isEmpty)! || (bankBranch.text?.isEmpty)! {
            return false
        }
        return true
    }
}

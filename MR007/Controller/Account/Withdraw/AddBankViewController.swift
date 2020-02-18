//
//  AddBankViewController.swift
//  MR007
//
//  Created by Roger Molas on 16/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

class AddBankViewcontroller: UIViewController {
    @IBOutlet weak var lblPlayerName: UILabel!
    @IBOutlet weak var bankNameField: UITextField!
    @IBOutlet weak var accountNumberField: UITextField!
    @IBOutlet weak var bankAddressField: UITextField!
    @IBOutlet weak var remarksField: UITextField!

    var userFullname = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblPlayerName.text = userFullname
    }

    @IBAction func sendRequest () {
        self.requestAddBankAccount()
    }

    func requestAddBankAccount() {
        let request = WithdrawalRequestManager()
        LoadingView.nativeProgress()
        request.requestAdd(completionHandler: { (user, response) in
            self.clearFields()
            Alert.with(title: "Add Bank", message: response)
        }, error: { (error) in

        }, params: self.getddBankParam())

    }

    func clearFields() {
        self.bankNameField.text = ""
        self.accountNumberField.text = ""
        self.bankAddressField.text = ""
        self.remarksField.text = ""
    }

    func getddBankParam() -> NSDictionary {
        let param = NSDictionary(dictionaryLiteral: ("accountName", lblPlayerName.text ?? ""),
                                 ("bankName", bankNameField.text ?? ""),
                                 ("bankAccount", accountNumberField.text ?? ""),
                                 ("bankBranch", bankAddressField.text ?? ""),
                                 ("remarks", remarksField.text ?? ""))
        return param
    }
}

// MARK: - UITextFieldDelegate
extension AddBankViewcontroller: UITextFieldDelegate {

}

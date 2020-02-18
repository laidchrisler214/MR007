//
//  PaymentOfflineViewController.swift
//  MR007
//
//  Created by GreatFeat on 17/05/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

class PaymentOfflineViewController: BaseViewController {
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var amountLabel: AmountLabel!
    
    @IBOutlet weak var selectedBankLabel: UILabel!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var accountNumberLabel: UILabel!
    @IBOutlet weak var bankNameLabel: UILabel!
    
    @IBOutlet weak var keypadView: UIView!
    
    var banks = [BankModel]()
    var currentBank: BankModel? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.confirmButton.isEnabled = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PaymentOfflineViewController.showKeyPad))
        self.amountLabel.addGestureRecognizer(tapGesture)
    }

    func showKeyPad() {
        // Dismiss all active keyboards
        self.isEditing = true
        self.view.resignFirstResponder()

        let keypad = KeypadView.loadView()
        keypad.set(inputView: &self.amountLabel)
        self.amountLabel.isUserInteractionEnabled = true
        self.keypadView.addSubview(keypad)
        keypad.frame = self.keypadView.frame
        keypad.center.x = self.keypadView.frame.size.width / 2
        keypad.center.y = self.keypadView.frame.size.height / 2
    }

    @IBAction func viewDebitCards() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let debitCardView = storyboard.instantiateViewController(withIdentifier: StoryboardId.debitCard) as? DebitCardViewController
        debitCardView?.banks = self.banks
        debitCardView?.delegate = self
        self.present(debitCardView!, animated: false)
    }

    func clearFields() {
        self.amountLabel.text = ""
        self.accountNameLabel.text = ""
        self.accountNumberLabel.text = ""
        self.bankNameLabel.text = ""
    }

    @IBAction func submitDepositAction () {
        self.sendDepositToExistingBank()
    }
}

// MARK: DebitCardViewDelegate
extension PaymentOfflineViewController: DebitCardViewDelegate {
    func didAddDebitCardRequest() {
        self.performSegue(withIdentifier: Segue.addDebitCard, sender: nil)
    }

    func didSelectBank(bank: BankModel) {
        self.confirmButton.isEnabled = true
        self.currentBank = bank
        self.selectedBankLabel.text = currentBank?.bankName
        self.accountNameLabel.text = currentBank?.bankName
        self.accountNumberLabel.text = currentBank?.cardId
        self.bankNameLabel.text = currentBank?.bankName
    }
}

// MARK: - API Request / Param builder
extension PaymentOfflineViewController {
    /// Send deposit request to existing bank
    func sendDepositToExistingBank() {
        let request = DepositRequestManager()
        LoadingView.nativeProgress()
        request.sendDepositExistingBank(completionHandler: { (user, message) in
            Alert.with(title: alertMessage.success, message: message)
            self.clearFields()

        }, error: { (error) in
            LoadingView.hide()

        }, params: self.getParamExistingBank())
    }

    func getParamExistingBank() -> NSDictionary {
        let category = currentBank?.category
        let param = NSDictionary(dictionaryLiteral: ("category", "\(category!)"), ("amount", self.accountNameLabel.text ?? ""),
                                 ("id", self.currentBank?.bankId ?? "" ), // Bank ID
            ("remitter", accountNameLabel.text ?? ""),
            ("remitter_bank", bankNameLabel.text ?? ""),
            ("remitter_account", accountNumberLabel.text ?? ""),
            ("pay_way", "ATM"),
            ("remarks", "Test Deposit"))
        return param
    }
}

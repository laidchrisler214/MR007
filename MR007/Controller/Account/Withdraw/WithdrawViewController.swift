//
//  WithdrawViewController.swift
//  MR007
//
//  Created by Dwaine Alingarog on 01/12/2016.
//  Copyright © 2016 Greafeat Services Inc. All rights reserved.
//

import UIKit
import Crashlytics

class WithdrawViewController: BaseViewController {
    @IBOutlet weak var bankIcon: UIImageView!
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var limitLabel: UILabel!
    @IBOutlet weak var dailyLimitLabel: UILabel!
    @IBOutlet weak var limitDetailLabel: UILabel!

    var currentBank: WithdrawalBankModel? = nil
    var bankId = String()
    var sharedUser = SharedUserInfo.sharedInstance
    var minWithdraw = Int()
    var maxWithdraw = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        amountField.becomeFirstResponder()
        getWithdrawalLimit()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        amountField.becomeFirstResponder()
        if let balance = self.loadUserDefault(key: Account.accountBalanceRecord) as? String {
            var formattedBalance = Double(balance)
            formattedBalance = round(1000 * formattedBalance!) / 1000
            self.balanceLabel.text = "主账户余额：¥\(String(format: "%.2f", formattedBalance!))"
        }
    }

    func getWithdrawalLimit() {
        let param = ["loginName":sharedUser.getUserLoginName()] as NSDictionary
        let request = WithdrawalRequestManager()
        LoadingView.nativeProgress()
        request.getWithdrawalLimit(completionHandler: { (user, limitModel) in
            LoadingView.hide()
            self.minWithdraw = (limitModel?.minWithdraw)!
            self.maxWithdraw = (limitModel?.maxWithdraw)!
            self.limitLabel.text = "每笔提款限额：¥\((limitModel?.minWithdraw)!) ~ \((limitModel?.maxWithdraw)!)"
            self.dailyLimitLabel.text = "每日提款限额：¥\((limitModel?.dailyWithdrawalLimit)!)"
            self.limitDetailLabel.text = "剩余可提款次数：20；剩余可提款额度：¥\((limitModel?.dailyWithdrawalLimit)!)"
            self.saveUserDefault(item: (limitModel?.dailyWithdrawalLimit)!, key: Account.dailyWithdrawLimit)
            self.saveUserDefault(item: (limitModel?.minWithdraw)!, key: Account.minWithdrawLimit)
            self.saveUserDefault(item: (limitModel?.maxWithdraw)!, key: Account.maxWithdrawLimit)
        }, error: { (error) in
            LoadingView.hide()
        }, param: param)
    }

    @IBAction func viewDebitCards() {
        amountField.resignFirstResponder()
        if let popOverVC:PopUpBanksViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUp Banks View") as? PopUpBanksViewController {
            amountField.resignFirstResponder()
            popOverVC.delegate = self
            self.addChildViewController(popOverVC)
            self.view.addSubview(popOverVC.view)
            popOverVC.didMove(toParentViewController: self)
        }
    }

    /// Request Withdrawal
    @IBAction func requestWithdrawal() {
        if fieldIsValid() {
            let sharedUser = SharedUserInfo.sharedInstance
            let request = WithdrawalRequestManager()
            LoadingView.nativeProgress()
            request.requestWithdrawal(completionHandler: { (user, response) in
                LoadingView.hide()
                Answers.logCustomEvent(withName: "Withdraw", customAttributes: ["loginName": sharedUser.getUserName() , "email": user?.email ?? "", "lastLogInIp": user?.lastLogInIp ?? "", "balance": user?.balance ?? "", "amount": self.amountField.text!, "bankId":self.bankId, "response": response ?? "" ])

                self.showAlert(message: response!)
            }, error: { (error) in

            }, params: self.getWithdrawalParam())
        }
    }

    func getWithdrawalParam() -> NSDictionary {
        let param = ["bankId":self.bankId, "amount": amountField.text ?? ""] as NSDictionary
        return param
    }

    func fieldIsValid() -> Bool {
        if (amountField.text?.isEmpty)! {
            Alert.with(title: alertMessage.error, message: alertMessage.amountIsEmpty)
            return false
        }

        if Int(amountField.text!)! < minWithdraw {
            Alert.with(title: alertMessage.error, message: alertMessage.cannotBeLessThanMinWithdraw)
            return false
        }

        if Int(amountField.text!)! > maxWithdraw {
            Alert.with(title: alertMessage.error, message: alertMessage.cannotExceedMaxWithdraw)
            return false
        }

        return true
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: alertMessage.success, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: alertMessage.dismiss, style: .default, handler: { (action: UIAlertAction!) in
            self.performSegueToReturnBack()
        }))
        present(alert, animated: true, completion: nil)
    }
}

//MARK: Pop Up Bank Delegate
extension WithdrawViewController: PopUpBankDelegate {
    func saveSelectedBank(bankName: String, bankId: String, bankIcon: UIImage, bankAccountNumber: String) {
        self.bankNameLabel.text = "\(bankName) (\(bankAccountNumber.suffix(4)))"
        self.bankIcon.image = bankIcon
        self.bankId = bankId
        amountField.becomeFirstResponder()
    }

    func canceledPopUpBank() {
        amountField.becomeFirstResponder()
    }
}

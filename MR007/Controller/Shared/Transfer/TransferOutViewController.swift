//
//  TransferOutViewController.swift
//  MR007
//
//  Created by GreatFeat on 26/10/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit
import Crashlytics

protocol TransferOutDelegate {
    func transferOutComplete(newBalance: String)
}

class TransferOutViewController: BaseViewController {

    //MARK: - OULETS

    @IBOutlet weak var mainWalletAmount: UILabel!
    @IBOutlet weak var subWalletAmount: UILabel!
    @IBOutlet weak var subWalletLabel: UILabel!
    @IBOutlet weak var amountField: UITextField!

    //MARK: - PROPERTIES
    var isTransferSuccess = Bool()
    var platformCode = String()
    var platformName = String()
    var mainWalletBalance = String()
    var subWalletBalance = String()
    var delegate: TransferOutDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showAnimate()
        self.addGestureToSuperViewForDismissingKeyboard()
        isTransferSuccess = false
        getMainWalletBalance()
    }

    //MARK: - API
    func getMainWalletBalance() {
        if !isTransferSuccess {
            LoadingView.nativeProgress()
        }
        let request = AccountRequestManager()
        request.getAccountDetails(completionHandler: { (user, platforms) in
            self.mainWalletBalance = (user?.balance)!
            self.getSubWalletBalance()
        }) { (error) in
            LoadingView.hide()
        }
    }

    func getSubWalletBalance() {
        let request = BalanceRequestManager()
        request.getBalance(completionHandler: { (user, wallet) in
            LoadingView.hide()
            self.subWalletBalance = (wallet?.balance)!
            self.setBalanceLabels()
        }, error: { (error) in
            LoadingView.hide()
        }, param: ["platform":self.platformCode] as NSDictionary)
    }

    //MARK: - HELPER
    func setBalanceLabels() {
        self.mainWalletAmount.text = self.mainWalletBalance
        self.subWalletAmount.text = self.subWalletBalance
        self.subWalletLabel.text = "\(self.platformName)账户余额"
    }

    func addGestureToSuperViewForDismissingKeyboard(){
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tapRecognizer)
    }

    func dismissKeyboard(){
        self.view.endEditing(true);
    }

    //MARK: - BUTTON ACTIONS
    @IBAction func cancelAction(_ sender: Any) {
        if self.isTransferSuccess {
            self.delegate?.transferOutComplete(newBalance: self.subWalletBalance)
        }
        self.removeAnimate()
    }
    @IBAction func doneAction(_ sender: Any) {
        if self.isTransferSuccess {
            self.delegate?.transferOutComplete(newBalance: self.subWalletBalance)
        }
        self.removeAnimate()
    }
    @IBAction func confirmAction(_ sender: Any) {
        if !(amountField.text?.isEmpty)! {
            let param = ["platform_code":self.platformCode, "amount":amountField.text!] as NSDictionary
            let request = TransferRequestManager()
            let sharedUser = SharedUserInfo.sharedInstance
            LoadingView.nativeProgress()
            request.requestTransferOut(completionHandler: { (user, response) in
                LoadingView.hide()
                Answers.logCustomEvent(withName: "Transfer-Out", customAttributes: ["user": sharedUser.getUserName(), "email": user?.email ?? "", "balance": user?.balance ?? "", "platform_code": self.platformCode, "amount": self.amountField.text!, "response": response ?? "" ])
                self.isTransferSuccess = true
                self.getMainWalletBalance()
                Alert.with(title: alertMessage.success, message: response)
            }, error: { (error) in
                LoadingView.hide()
            }, params: param)
        }
    }
}

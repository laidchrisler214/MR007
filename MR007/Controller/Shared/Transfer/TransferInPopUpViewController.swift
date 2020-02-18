//
//  TransferInPopUpViewController.swift
//  MR007
//
//  Created by GreatFeat on 26/10/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit
import Crashlytics

protocol TransferInDelegate {
    func transferInComplete(newBalance: String)
}

class TransferInPopUpViewController: BaseViewController {

    //MARK: - OUTLETS
    @IBOutlet weak var mainWalletAmount: UILabel!
    @IBOutlet weak var subWalletAmount: UILabel!
    @IBOutlet weak var subWalletLabel: UILabel!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var transferBonusOutlet: UIButton!

    //MARK: - PROPERTIES
    var isTransferSuccess = Bool()
    var platformCode = String()
    var platformName = String()
    var mainWalletBalance = String()
    var subWalletBalance = String()
    var delegate: TransferInDelegate? = nil
    var bonusId = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showAnimate()
        self.addGestureToSuperViewForDismissingKeyboard()
        isTransferSuccess = false
        getMainWalletBalance()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let bonusName = self.loadUserDefault(key: Account.selectedBonusName) as? String {
            transferBonusOutlet.setTitle(bonusName, for: .normal)
            self.removeUserDefault(key: Account.selectedBonusName)
        }

        if let idBonus = self.loadUserDefault(key: Account.selectedBonusId) as? String {
            bonusId = idBonus
            self.removeUserDefault(key: Account.selectedBonusId)
        }
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
            self.delegate?.transferInComplete(newBalance: self.subWalletBalance)
        }
        self.removeAnimate()
    }
    @IBAction func doneAction(_ sender: Any) {
        if self.isTransferSuccess {
            self.delegate?.transferInComplete(newBalance: self.subWalletBalance)
        }
        self.removeAnimate()
    }
    @IBAction func confirmAction(_ sender: Any) {
        if !(amountField.text?.isEmpty)! {
            let param = ["platform_code":self.platformCode, "bonus_id": self.bonusId, "amount":amountField.text!] as NSDictionary
            let sharedUser = SharedUserInfo.sharedInstance
            let request = TransferRequestManager()
            LoadingView.nativeProgress()
            request.requestTransferIn(completionHandler: { (user, response) in
                LoadingView.hide()
                Answers.logCustomEvent(withName: "Transfer-In", customAttributes: ["user": sharedUser.getUserName(), "balance": user?.balance ?? "", "platform_code": self.platformCode, "amount": self.amountField.text!, "response": response ?? "" ])
                self.isTransferSuccess = true
                self.getMainWalletBalance()
                Alert.with(title: self.alertMessage.success, message: response)
            }, error: { (error) in
                LoadingView.hide()
            }, params: param)
        }
    }
    @IBAction func transferBonus(_ sender: Any) {
        if let popOverVC:TransferBonusPopUpViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TransferBonusPopUpViewController") as? TransferBonusPopUpViewController {
            popOverVC.delegate = self
            popOverVC.platform = self.platformCode
            self.addChildViewController(popOverVC)
            self.view.addSubview(popOverVC.view)
            popOverVC.didMove(toParentViewController: self)
        }
    }

}

extension TransferInPopUpViewController: TransferBonusDelegate {
    func transferBonusSelected(bonusId: String, bonusName: String) {
        self.bonusId = bonusId
        self.transferBonusOutlet.setTitle(bonusName, for: .normal)
    }
}

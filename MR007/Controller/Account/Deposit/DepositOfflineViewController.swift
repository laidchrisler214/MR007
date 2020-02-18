//
//  DepositOfflineViewController.swift
//  MR007
//
//  Created by GreatFeat on 19/10/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit
import Crashlytics

class DepositOfflineViewController: BaseViewController {

    //MARK: - OUTLETS
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var digitField: UITextField!
    @IBOutlet weak var userBankName: UITextField!
    @IBOutlet weak var recipientName: UITextField!
    @IBOutlet weak var recipientAccountNumber: UITextField!
    @IBOutlet weak var branchBackAddress: UITextField!
    @IBOutlet weak var remitterBank: UITextField!

    //MARK: - PROPERTIES
    var payWays = [String]()
    var bank = BankModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureToSuperViewForDismissingKeyboard()
        setViewLayout()
    }

    //MARK: - API
    func submitAndDeposit() {
        let sharedUser = SharedUserInfo.sharedInstance
        let params = ["category": bank.category, "amount": amountField.text!, "id": String(bank.bankId)!, "remitter": userNameField.text!, "remitter_bank": remitterBank.text!, "remitter_account": digitField.text!, "pay_way": userBankName.text!, "remarks": ""] as NSDictionary
        LoadingView.nativeProgress()
        let request = DepositRequestManager()
        request.sendDepositExistingBank(completionHandler: { (user, response) in
            LoadingView.hide()
            Answers.logCustomEvent(withName: "Deposit Offline", customAttributes: ["user": sharedUser.getUserName() , "amount": self.amountField.text!, "remitter_bank": self.remitterBank.text!, "remitter_account": self.digitField.text!, "response": response ?? "" ])

            self.showAlert(message: response!)
        }, error: { (error) in
            LoadingView.hide()
        }, params: params)
    }

    //MARK: - HELPER
    func setViewLayout() {
        recipientName.text = bank.accountName
        recipientAccountNumber.text = bank.cardId
        branchBackAddress.text = bank.address
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: alertMessage.success, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: alertMessage.dismiss, style: .default, handler: { (action: UIAlertAction!) in
            self.performSegueToReturnBack()
        }))
        present(alert, animated: true, completion: nil)
    }

    func addGestureToSuperViewForDismissingKeyboard(){
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tapRecognizer)
    }

    func dismissKeyboard(){
        self.view.endEditing(true);
    }

    @IBAction func depositAction(_ sender: Any) {
        if (remitterBank.text?.isEmpty)! || (userBankName.text?.isEmpty)! || (amountField.text?.isEmpty)! || (userNameField.text?.isEmpty)! || (digitField.text?.isEmpty)! ||  (userBankName.text?.isEmpty)! {
            Alert.with(title: alertMessage.error, message: alertMessage.fieldIsEmptyError)
        } else {
            submitAndDeposit()
        }
    }

    @IBAction func selectDepositMethod(_ sender: Any) {
        if let popOverVC:DepositMethodViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DepositMethodViewController") as? DepositMethodViewController {
            popOverVC.delegate = self
            popOverVC.pickerData = self.payWays
            self.addChildViewController(popOverVC)
            self.view.addSubview(popOverVC.view)
            popOverVC.didMove(toParentViewController: self)
        }
    }
}

extension DepositOfflineViewController: DepositMethodViewControllerDelegate {
    func returnSelectedMethod(depositMethod: String) {
        self.userBankName.text = depositMethod
    }
}

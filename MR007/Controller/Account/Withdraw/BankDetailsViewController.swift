//
//  BankDetailsViewController.swift
//  MR007
//
//  Created by Roger Molas on 17/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

class BankDetailsViewController: BaseViewController {
    @IBOutlet weak var lblBankName: UILabel!
    @IBOutlet weak var lblAccountName: UILabel!
    @IBOutlet weak var lblAccountNumber: UILabel!

    var bank: WithdrawalBankModel? = nil // current bank

    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblBankName.text = bank?.bankName
        self.lblAccountNumber.text = bank?.accountNumber
        self.lblAccountName.text = bank?.accountName
    }

    @IBAction func deleteAction () {
        self.requestDelete(bank: bank!)
    }

    /// Request Delete Bank
    func requestDelete(bank: WithdrawalBankModel) {
        let request = WithdrawalRequestManager()
        LoadingView.nativeProgress()
        request.requestDelete(completionHandler: { (user, response) in
            Alert.with(title: self.alertMessage.delete, message: response)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                _ = self.navigationController?.popViewController(animated: true)
            }
        }, error: { (error) in

        }, params: ["id":bank.bankId])
    }
}

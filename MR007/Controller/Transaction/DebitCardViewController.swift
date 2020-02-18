//
//  DebitCardViewController.swift
//  MR007
//
//  Created by GreatFeat on 19/05/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

protocol DebitCardViewDelegate: NSObjectProtocol {
    func didAddDebitCardRequest()
    func didSelectBank(bank: BankModel)
}

class DebitCardViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!

    var currentCell: UITableViewCell? = nil
    
    var banks = [BankModel]()
    var currentBank: BankModel? = nil

    weak var delegate: DebitCardViewDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        var rect = self.containerView.frame
        rect.origin.y = rect.maxY
        containerView.frame = rect
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.show()
    }

    @IBAction func doneAction () {
        self.delegate?.didSelectBank(bank: self.currentBank!)
        self.dismiss()
    }

    @IBAction func cancelAction () {
        self.dismiss()
    }

    func show() {
        var rect = self.containerView.frame
        UIView.animate(withDuration: 0.25, animations: {
            rect.origin.y -= rect.size.height
            self.containerView.frame = rect
        }) { (flag) in
        }
    }

    func dismiss() {
        var rect = self.containerView.frame
        UIView.animate(withDuration: 0.25, animations: {
            rect.origin.y = rect.maxY
            self.containerView.frame = rect
        }) { (flag) in
            self.dismiss(animated: false, completion: nil)
        }
    }

//    /// Request Bank Binding
//    func requestBankList() {
//        let request = WithdrawalRequestManager()
//        request.requestBankList(completionHandler: { (user, bankList) in
//            self.banks = (bankList as? [WithdrawalBankModel])!
//            self.tableView.reloadData()
//        }) { (error) in
//
//        }
//    }
}

extension DebitCardViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return banks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let bank = banks[indexPath.row]
        cell.textLabel?.text = bank.bankName
        return cell
    }
}

extension DebitCardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 4 {
            delegate?.didAddDebitCardRequest()
        } else {
            let currentBank = banks[indexPath.row]
            self.currentBank = currentBank
        }

        if currentCell != nil {
            currentCell?.accessoryType = .none
        }

        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        self.currentCell = cell

    }
}

//
//  BankListViewController.swift
//  MR007
//
//  Created by Roger Molas on 16/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

class BankListViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    fileprivate var banks = [WithdrawalBankModel]()
    fileprivate var bankListener: ((WithdrawalBankModel) -> Swift.Void?)? = nil
    fileprivate var currentCell: BankDetailsCell? = nil

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        LoadingView.nativeProgress()
        self.requestBankList()
    }

    func setListener(bankListener: ((WithdrawalBankModel) -> Swift.Void)? = nil) {
        self.bankListener = bankListener
    }

    /// Request Bank Binding
    func requestBankList() {
        let request = WithdrawalRequestManager()
        request.requestBankList(completionHandler: { (user, bankList) in
            self.banks = (bankList as? [WithdrawalBankModel])!
            self.tableView.reloadData()
            LoadingView.hide()
        }) { (error) in
            LoadingView.hide()
        }
    }

    func addBankAction() {
        performSegue(withIdentifier: "segueToAddDebitCard", sender: self)
    }

    func deleteBank(index: Int) {
        let deleteAlert = UIAlertController(title: alertMessage.deleteTheBank, message: "", preferredStyle: UIAlertControllerStyle.alert)
        deleteAlert.addAction(UIAlertAction(title: alertMessage.no, style: .cancel, handler: nil))
        deleteAlert.addAction(UIAlertAction(title: alertMessage.yes, style: .default, handler: { (action: UIAlertAction!) in
            LoadingView.nativeProgress()
            let params = ["id":self.banks[index].bankId] as NSDictionary
            self.tableView.setEditing(false, animated: true)
            let request = WithdrawalRequestManager()
            request.requestDelete(completionHandler: { (user, message) in
                DispatchQueue.main.async {
                    self.requestBankList()
                }
            }, error: { (error) in
                LoadingView.hide()
            }, params: params)
        }))
        present(deleteAlert, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension BankListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return banks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BankDetailsCell.getCell(tableView: tableView)
        let bank = banks[indexPath.row]
        cell.set(bank: bank)
        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddBankTableFooter") as? AddBankTableFooter
        cell?.footerButton.addTarget(self, action: #selector(addBankAction), for: UIControlEvents.touchUpInside)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 75.0
    }
}

// MARK: - UITableViewDelegate
extension BankListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let selected = banks[indexPath.row]
//        bankListener!(selected)
//
//        // Set selected cell
//        if currentCell != nil {
//            currentCell?.isCurrentSelection = false
//            currentCell?.accessoryType = .none
//            currentCell?.layoutSubviews()
//        }
//
//        let cell = tableView.cellForRow(at: indexPath) as? BankDetailsCell
//        cell?.accessoryType = .checkmark
//        cell?.isCurrentSelection = false
//        currentCell = cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteBank(index: indexPath.row)
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
}

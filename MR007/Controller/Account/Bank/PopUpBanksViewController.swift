//
//  PopUpBanksViewController.swift
//  MR007
//
//  Created by GreatFeat on 16/10/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

protocol PopUpBankDelegate {
    func saveSelectedBank(bankName: String, bankId: String, bankIcon: UIImage, bankAccountNumber: String)
    func canceledPopUpBank()
}

class PopUpBanksViewController: BaseViewController {

    //MARK: OUTLETS
    @IBOutlet weak var tableHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!

    //MARK: PROPERTIES
    fileprivate var banks = [WithdrawalBankModel]()
    fileprivate var isSelectedArray = [Bool]()
    var selectedIndex = Int()
    var delegate: PopUpBankDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showAnimate()
        LoadingView.nativeProgress()
        self.requestBankList()
    }

    //MARK: API
    func requestBankList() {
        let request = WithdrawalRequestManager()
        request.requestBankList(completionHandler: { (user, bankList) in
            self.banks = (bankList as? [WithdrawalBankModel])!
            self.initializeSelectedCells()
            self.setTableHeight()
            self.tableView.reloadData()
            LoadingView.hide()
        }) { (error) in
            LoadingView.hide()
        }
    }

    //MARK: HELPERS
    func segueAddBankAction() {
        self.performSegue(withIdentifier: "segueToAddDebitCard", sender: self)
    }

    func cancelAction() {
        self.delegate?.canceledPopUpBank()
        self.removeAnimate()
    }

    func carryOutAction() {
        var bankIcon = UIImage()
        if banks[selectedIndex].bankName.lowercased() == "abc" {
            bankIcon = #imageLiteral(resourceName: "ABC")
        } else if banks[selectedIndex].bankName.lowercased() == "ccb" {
            bankIcon = #imageLiteral(resourceName: "CCB")
        } else if banks[selectedIndex].bankName.lowercased() == "cmb" {
            bankIcon = #imageLiteral(resourceName: "CMB")
        } else if banks[selectedIndex].bankName.lowercased() == "icbc" {
            bankIcon = #imageLiteral(resourceName: "ICBC")
        } else {
            bankIcon = #imageLiteral(resourceName: "blueCardIcon")
        }
        self.delegate?.saveSelectedBank(bankName: banks[selectedIndex].bankName, bankId: banks[selectedIndex].bankId, bankIcon: bankIcon, bankAccountNumber: banks[selectedIndex].accountNumber)
        self.removeAnimate()
    }

    func initializeSelectedCells() {
        for _ in 0..<self.banks.count {
            self.isSelectedArray.append(false)
        }
    }

    func setTableHeight() {
        if self.banks.count > 0 {
            let height = CGFloat(self.banks.count * 75) + 200.0
            self.tableHeightConstant.constant = height
        } else {
            let height = CGFloat(330.0)
            self.tableHeightConstant.constant = height
        }
    }
}

//MARK: TABLE DATA SOURCE
extension PopUpBanksViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return banks.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddBanksHeaderCell") as? AddBanksHeaderCell
        cell?.cancelButton.addTarget(self, action: #selector(cancelAction), for: UIControlEvents.touchUpInside)
        cell?.carryOutButton.addTarget(self, action: #selector(carryOutAction), for: UIControlEvents.touchUpInside)
        return cell
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BankDetailsCell.getCell(tableView: tableView)
        let bank = banks[indexPath.row]
        cell.setWithCheckMark(bank: bank, isSelected: self.isSelectedArray[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddBankFooterCell") as? AddBankFooterCell
        cell?.addButton.addTarget(self, action: #selector(segueAddBankAction), for: UIControlEvents.touchUpInside)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55.0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 75.0
    }
}

//MARK: TABLEVIEW DELEGATE
extension PopUpBanksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0..<self.isSelectedArray.count {
            self.isSelectedArray[i] = false
        }
        self.isSelectedArray[indexPath.row] = true
        self.selectedIndex = indexPath.row
        tableView.reloadData()
    }
}

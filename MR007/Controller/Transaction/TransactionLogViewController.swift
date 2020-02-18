//
//  TransactionLogViewController.swift
//  MR007
//
//  Created by GreatFeat on 30/10/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

class TransactionLogViewController: UIViewController {

    // MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterButtonOutlet: UIBarButtonItem!


    // MARK: - PROPERTIES
    var transactions = [TransactionLogModel]()
    var filters = [TransactionFilterModel]()
    var filter = "0"

    override func viewDidLoad() {
        super.viewDidLoad()
        //DropdownIcon is the image asset, set in main story board. for now temporarily hide
        filterButtonOutlet.isEnabled = false
        getTransactionLogs()

    }

    // MARK: API
    func getTransactionLogs() {
        LoadingView.nativeProgress()
        let param = ["type": filter, "startDate": get30DayBeforeDate(), "endDate": getCurrentDate()] as NSDictionary
        let request = TransactionLogRequestManager()
        request.getTransactionLogs(completionHandler: { (user, transaction) in
            LoadingView.hide()
            self.transactions = (transaction?.transactionLogs)!
            self.filters = (transaction?.transactionFilters)!
            self.tableView.reloadData()
        }, error: { (error) in
            LoadingView.hide()
        }, params: param)
    }

    func filterTransactionLogs() {
        self.transactions.removeAll()
        LoadingView.nativeProgress()
        let param = ["type": filter, "startDate": get30DayBeforeDate(), "endDate": getCurrentDate()] as NSDictionary
        let request = TransactionLogRequestManager()
        request.getTransactionLogs(completionHandler: { (user, transaction) in
            LoadingView.hide()
            self.transactions = (transaction?.transactionLogs)!
            self.tableView.reloadData()
        }, error: { (error) in
            LoadingView.hide()
        }, params: param)
    }

    // MARK: - HELPER
    func getCurrentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        return result
    }

    func get30DayBeforeDate() -> String {
        let date = Date()
        let thirtyDaysBeforeToday = Calendar.current.date(byAdding: .day, value: -30, to: date)!
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: thirtyDaysBeforeToday)
        return result
    }

    // MARK: - BUTTON ACTIONS
    @IBAction func dropDownFilter(_ sender: Any) {
        if let popOverVC:TransactionFilterController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TransactionFilterController") as? TransactionFilterController {
            filterButtonOutlet.isEnabled = false
            popOverVC.delegate = self
            popOverVC.filters = self.filters
            self.addChildViewController(popOverVC)
            self.view.addSubview(popOverVC.view)
            popOverVC.didMove(toParentViewController: self)
        }
    }

}

// MARK: - TABLE Data source and Delegate
extension TransactionLogViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionLogsCell", for: indexPath) as? TransactionLogsCell
        cell?.set(data: self.transactions[indexPath.row])
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 87
    }
}

extension TransactionLogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

// MARK: - Filter Delegate
extension TransactionLogViewController: TransactionFilterDelegate {
    func didSelectFilter(filterType: String) {
        filterButtonOutlet.isEnabled = true
        filter = filterType
        filterTransactionLogs()
    }

}

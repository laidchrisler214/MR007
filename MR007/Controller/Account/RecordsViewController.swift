//
//  RecordsViewController.swift
//  MR007
//
//  Created by Dwaine Alingarog on 01/12/2016.
//  Copyright © 2016 Greafeat Services Inc. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class RecordsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnStartDate: UIButton!
    @IBOutlet weak var btnEndDate: UIButton!
    @IBOutlet weak var btnFilter: UIButton!

    var filters = [FilterModel]()
    var transactions = [HistoryModel]()
    var dateFormat = "yyyy-MM-dd"
    var type = "1"
    var startDate = ""
    var endDate = ""

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Get the previous month history
        let calendar = NSCalendar.current
        var comps = DateComponents()
        comps.month = -1
        comps.day   = -1
        let date = calendar.date(byAdding: comps as DateComponents, to: Date())

        let startDateFormatter = DateFormatter()
        startDateFormatter.dateFormat = dateFormat
        self.startDate = "\(startDateFormatter.string(from: (date)!))"
        self.btnStartDate.setTitle(self.startDate, for: .normal)

        let endDateFormatter = DateFormatter()
        endDateFormatter.dateFormat = dateFormat
        self.endDate = "\(endDateFormatter.string(from: (Date())))"
        self.btnEndDate.setTitle(self.endDate, for: .normal)

        self.getHistory()
    }

    // Get Transaction history
    func getHistory() {
        let request = HistoryRequestManager()
        LoadingView.nativeProgress()
        request.getTransactions(completionHandler: { (user, filters, transactionList) in
            self.transactions = (transactionList as? [HistoryModel])!
            self.filters = (filters as? [FilterModel])!
            self.tableView.reloadData()
            LoadingView.hide()
        }, error: { (error) in

        }, params: getParam())
    }

    @IBAction func startDateAction() {
        let datePicker = ActionSheetDatePicker(title: "Start Date",
                                               datePickerMode: .date,
                                               selectedDate: Date(),
                                               doneBlock: { (picker, value, index) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = self.dateFormat
            self.startDate = "\(dateFormatter.string(from: (value as? Date)!))"
            self.btnStartDate.setTitle(self.startDate, for: .normal)
        }, cancel: { (picker) in

        }, origin: self.view)
        datePicker?.show()
    }

    @IBAction func endDateAction() {
        let datePicker = ActionSheetDatePicker(title: "End Date",
                                               datePickerMode: .date,
                                               selectedDate: Date(),
                                               doneBlock: { (picker, value, index) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = self.dateFormat
            self.endDate = "\(dateFormatter.string(from: (value as? Date)!))"
            self.btnEndDate.setTitle(self.endDate, for: .normal)
        }, cancel: { (picker) in

        }, origin: self.view)
        datePicker?.show()
    }

    @IBAction func search() {
        self.getHistory()
    }

    @IBAction func showFilter() {
        let filter = AlertViewOptions(title: nil, message: nil, preferredStyle: .alert)
        filter.contents = filters
        filter.setUpView()
        filter.delegate = self
        self.present(filter, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension RecordsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recordCell = RecordCell.getCell(tableView: tableView, indx: indexPath)
        recordCell.set(data: transactions[indexPath.row])
        return recordCell
    }

    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.copy(_:)) {
            return true
        }
        return false
    }

    func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        let cell = tableView.cellForRow(at: indexPath) as? RecordCell
        cell?.copyData()
    }
}

// MARK: - UITableViewDelegate
extension RecordsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - AlertViewOptionsDelegate
extension RecordsViewController: AlertViewOptionsDelegate {
    func didSelect<T>(item: T, option: AlertViewOptions) {
        let filter = (item as? FilterModel)?.cnLabel
        let filterType = (item as? FilterModel)?.type
        self.type = "\(filterType!)"
        self.btnFilter.setTitle(filter, for: .normal)
        self.getHistory()
    }
}

// MARK: - URL Param
extension RecordsViewController {
    func getParam() -> NSDictionary {
        let param = NSDictionary(dictionaryLiteral: ("type", type),
                                 ("startDate", self.startDate),
                                 ("endDate", self.endDate))
        return param
    }
}

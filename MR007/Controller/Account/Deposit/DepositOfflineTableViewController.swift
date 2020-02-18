//
//  DepositOfflineTableViewController.swift
//  MR007
//
//  Created by GreatFeat on 17/10/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

class DepositOfflineTableViewController: UITableViewController {

    var categoryId = String()
    var banks = [BankModel]()
    var payWays = [String]()
    var selectedIndex = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getBanks()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: - API
    func getBanks() {
        LoadingView.nativeProgress()
        let request = DepositRequestManager()
        request.getDepositGateway(id: self.categoryId, completionHandler: { (user, depositModelData) in
            LoadingView.hide()
            self.banks = (depositModelData?.banks)!
            self.payWays = (depositModelData?.payway)!
            self.tableView.reloadData()
        }) { (error) in
            LoadingView.hide()
        }
    }

    //MARK: - Helper
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? DepositOfflineViewController {
            viewController.bank = self.banks[self.selectedIndex]
            viewController.payWays = self.payWays
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.banks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DepositOfflineTableViewCell", for: indexPath) as? DepositOfflineTableViewCell
        cell?.set(data: self.banks[indexPath.row])
        return cell!
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }

    //MARK: - Table view Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "segueToDeposit", sender: self)
    }
}

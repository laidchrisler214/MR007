//
//  DepositOnlineTableViewController.swift
//  MR007
//
//  Created by GreatFeat on 17/10/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

class DepositOnlineTableViewController: UITableViewController {

    var categoryId = String()
    var category = String()
    var depositGateway = [GateWayModel]()
    var gateWayId = String()
    var gateWayCategory = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavitationBarTitle()
        getDepositGateway()
    }

    //MARK: - API
    func getDepositGateway() {
        LoadingView.nativeProgress()
        let request = DepositRequestManager()
        request.getDepositGateway(id: self.categoryId, completionHandler: { (user, depositModelData) in
            LoadingView.hide()
            self.depositGateway = (depositModelData?.gateways)!
            self.tableView.reloadData()
        }) { (error) in
            LoadingView.hide()
        }
    }

    //MARK: - Helper
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? PaymentLineViewController {
            viewController.gateWayId = self.gateWayId
            viewController.gatewayCategory = self.gateWayCategory
            viewController.payment = self.category
        }
    }

    func setNavitationBarTitle() {
        if category == "qq" {
            self.navigationItem.title = "QQ钱包"
        } else if category == "wechat" {
            self.navigationItem.title = "微信支付"
        } else if category == "alipay" {
            self.navigationItem.title = "支付宝"
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return depositGateway.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DepositGatewayCell", for: indexPath) as? DepositGatewayCell
        cell?.set(data: self.depositGateway[indexPath.row], category: self.category)
        return cell!
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }

    //MARK: - Table view Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.gateWayId = depositGateway[indexPath.row].gateWayId
        self.gateWayCategory = String(depositGateway[indexPath.row].category)
        self.performSegue(withIdentifier: "segueToOnlineDepositPayment", sender: self)
    }
}

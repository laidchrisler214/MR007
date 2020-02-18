//
//  AlipayViewController.swift
//  MR007
//
//  Created by GreatFeat on 15/05/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

class AlipayViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
     var methods = [GateWayModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
        self.requestDepositList()
    }

    func requestDepositList() {
        LoadingView.nativeProgress()
        let request = DepositRequestManager()
        request.getDepositList(completionHandler: { (user, methods) in

            for method: DepositMethodModel in methods! {
                if method.category == "alipay" {
                    self.methods = method.gateways
                    self.tableView.reloadData()
                    LoadingView.hide()
                }
            }
            LoadingView.hide()

        }) { (error) in
            LoadingView.hide()
        }
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destination = segue.destination as? PaymentLineViewController {
//            let method = sender as? GateWayModel
//            destination.payment = .alipay
//            destination.currentMethod = method
//        }
//    }
}

extension AlipayViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.methods.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let currentMethod = methods[indexPath.row]
        cell.textLabel?.text = currentMethod.label
        return cell
    }
}

extension AlipayViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let method = methods[indexPath.row]
        self.performSegue(withIdentifier: Segue.payment, sender: method)
    }
}

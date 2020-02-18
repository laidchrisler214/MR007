//
//  WechatPayViewController.swift
//  MR007
//
//  Created by GreatFeat on 15/05/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

class WechatPayViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var methods = [GateWayModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.requestDepositList()
    }

    func requestDepositList() {
        LoadingView.nativeProgress()
        let request = DepositRequestManager()
        request.getDepositList(completionHandler: { (user, methods) in
            for method: DepositMethodModel in methods! {
                if method.category == "wechat" {
                    self.methods = method.gateways
                    self.tableView.reloadData()
                    LoadingView.hide()
                    continue
                }
            }
        }) { (error) in
            LoadingView.hide()
        }
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destination = segue.destination as? PaymentLineViewController {
//            let method = sender as? GateWayModel
//            destination.payment = .wechat
//            destination.currentMethod = method
//        }
//    }
}

extension WechatPayViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.methods.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let method = self.methods[indexPath.row]
        cell.textLabel?.text = method.label
        return cell
    }
}

extension WechatPayViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let method = self.methods[indexPath.row]
        self.performSegue(withIdentifier: Segue.payment, sender: method)
    }
}

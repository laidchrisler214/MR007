//
//  OfflineDepositViewController.swift
//  MR007
//
//  Created by Roger Molas on 08/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

class OfflineDepositViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var methods = [DepositMethodModel]()

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
                if method.category == "offline" {
                    self.methods.append(method)
                }
            }

            LoadingView.hide()

        }) { (error) in
            LoadingView.hide()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PaymentOfflineViewController {
            let method = sender as? DepositMethodModel
            destination.banks = (method?.banks)!
        }
    }
}

// MARK: UITableViewDataSource
extension OfflineDepositViewController: UITableViewDataSource {
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

// MARK: UITableViewDelegate
extension OfflineDepositViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let method = methods[indexPath.row]
        self.performSegue(withIdentifier: Segue.offlineDeposit, sender: method)
    }
}

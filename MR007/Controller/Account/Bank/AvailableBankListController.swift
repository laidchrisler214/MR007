//
//  AvailableBankListController.swift
//  MR007
//
//  Created by GreatFeat on 12/10/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

class AvailableBankListController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!

    var bankIcons = [#imageLiteral(resourceName: "ABC"),#imageLiteral(resourceName: "CCB"),#imageLiteral(resourceName: "CMB"),#imageLiteral(resourceName: "ICBC")]
    var bankNames = ["ABC", "CCB", "CMB", "ICBC"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension AvailableBankListController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bankNames.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowAvailableBanksCell") as? ShowAvailableBanksCell
        cell?.setCell(bankName: bankNames[indexPath.row], bankIcon: bankIcons[indexPath.row])
        return cell!
    }
}

extension AvailableBankListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.saveUserDefault(item: bankNames[indexPath.row], key: Account.selectedBankName)
        self.goBackOneView()
    }
}

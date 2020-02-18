//
//  BalanceHeaderCell.swift
//  MR007
//
//  Created by GreatFeat on 04/10/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

class BalanceHeaderCell: BaseCell {

    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var headerRefreshButton: UIButton!
    private var currentUser = UserModel()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.headerRefreshButton.addTarget(self, action: #selector(refreshAction), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func set(user: UserModel) {
        var balance = Double(user.balance)
        balance = round(1000 * balance!) / 1000
        self.balanceLabel.text = "¥ \(String(format: "%.2f", balance!))"
    }

    @objc private func refreshAction () {
        getAccountBalance()
    }

    func getAccountBalance() {
        let request = AccountRequestManager()
        self.balanceLabel.text = "载入中"
        LoadingView.nativeProgress()
        request.getAccountDetails(completionHandler: { (user, platforms) in
            LoadingView.hide()
            self.set(user: user!)
        }) { (error) in
            //Alert.with(title: error., message: <#T##String?#>)
            LoadingView.hide()
        }
    }
}

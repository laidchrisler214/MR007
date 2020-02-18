//
//  WalletCell.swift
//  MR007
//
//  Created by Roger Molas on 03/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

class WalletCell: BaseCell {
    @IBOutlet weak var thumbnail:UIImageView!
    @IBOutlet weak var lblBalance:UILabel!
    @IBOutlet weak var lblDescription:UILabel!

    var action: ((Void) -> Void?)? = nil
    var gameCode: String = ""
    static let height:CGFloat = 88.0

    class func getCell(tableView: UITableView) -> WalletCell {
        var walletCell: WalletCell?
        walletCell = tableView.dequeueReusableCell(withIdentifier: CellType.MainWallet.rawValue) as? WalletCell
        if walletCell == nil {
            walletCell = WalletCell()
        }
        walletCell?.setActivity()
        return walletCell!
    }

    func setWallet(info: WalletModel) {
        self.lblBalance.text = info.balance
        self.done()
    }

    override func requesting() {
        super.requesting()
        self.lblBalance.text = "Loading..."
        if action != nil {
            action!()
        } else {
            self.requestBalance()
        }
    }

    // MARK: Request data
    func requestBalance() {
        guard self.gameCode != "" else {
            return
        }

        let request = BalanceRequestManager()
        request.getBalance(completionHandler: { (user, wallet) in
            self.setWallet(info: wallet!)

        }, error: nil, param:["platform":self.gameCode])
    }
}

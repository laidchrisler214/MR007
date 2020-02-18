//
//  AccountInfoCell.swift
//  MR007
//
//  Created by Roger Molas on 03/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

class AccountInfoCell: BaseCell {
    @IBOutlet weak var lblAccountName:UILabel!
    @IBOutlet weak var lblGreeting:UILabel!
    @IBOutlet weak var lblLastLogin:UILabel!
    static let height:CGFloat = 100.0

    class func getCell(tableView: UITableView) -> AccountInfoCell {
        var accountInfoCell: AccountInfoCell?
        accountInfoCell = tableView.dequeueReusableCell(withIdentifier: CellType.AccountInfo.rawValue) as? AccountInfoCell
        if accountInfoCell == nil {
            accountInfoCell = AccountInfoCell()
        }
        return accountInfoCell!
    }

    func set(user: UserModel?) {
        self.lblAccountName.text = user?.loginName
        self.lblLastLogin.text = user?.loginTime
    }
}

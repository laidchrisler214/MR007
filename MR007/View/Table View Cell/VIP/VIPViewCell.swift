//
//  VIPViewCell.swift
//  MR007
//
//  Created by Roger Molas on 08/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

fileprivate enum Cell: String {
    case vip    = "VIP Cell"
    case menu   = "Drop Down Cell"
}

protocol VIPViewCellDelegate: NSObjectProtocol {
    func didRequestClaim(bonus: VIPBonusModel)
}

/// Content Cell
class VIPViewCell: UITableViewCell {
    @IBOutlet weak var lblGroupName: UILabel!
    @IBOutlet weak var lblMinTransfer: UILabel!
    @IBOutlet weak var lblBonusRate: UILabel!
    @IBOutlet weak var lblWithdrawMultiple: UILabel!
    @IBOutlet weak var lblMaxBonusAmount: UILabel!
    @IBOutlet weak var btnClaim: UIButton!

    fileprivate var currentBonus:VIPBonusModel? = nil
    weak var delegate: VIPViewCellDelegate? = nil

    class func getCell(tableView:UITableView) -> VIPViewCell {
        var cell:VIPViewCell? = tableView.dequeueReusableCell(withIdentifier: Cell.vip.rawValue) as? VIPViewCell
        if cell == nil {
            cell = VIPViewCell()
        }
        cell?.btnClaim.addTarget(cell, action: #selector(VIPViewCell.requestClaimBonus), for: .touchUpInside)
        return cell!
    }

    func set(bonus: VIPBonusModel) {
        self.lblGroupName.text = bonus.bonusName
        self.lblMinTransfer.text = bonus.minTransferMessage
        self.lblBonusRate.text = bonus.bonusRateMessage
        self.lblWithdrawMultiple.text = bonus.withdrawalMessage
        self.lblMaxBonusAmount.text = bonus.maxBonusAmount
        self.currentBonus = bonus // reference current bonus
    }

    func requestClaimBonus() {
        self.delegate?.didRequestClaim(bonus: self.currentBonus!)
    }
}

/// Level Menu Cell
class VIPMenuCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!

    class func getCell(tableView:UITableView) -> VIPMenuCell {
        var cell:VIPMenuCell? = tableView.dequeueReusableCell(withIdentifier: Cell.menu.rawValue) as? VIPMenuCell
        if cell == nil {
            cell = VIPMenuCell()
        }
        return cell!
    }
}

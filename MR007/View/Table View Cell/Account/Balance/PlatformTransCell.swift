//
//  PlatformTransCell.swift
//  MR007
//
//  Created by Roger Molas on 03/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

public enum PlatformTransaction: Int {
    case Unknown = -1
    case TransferIn = 0
    case TransferOut = 1
    case Rebate = 2
}

class PlatformTransCell: BaseCell {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnAction: UIButton!
    var type: Int = -1

    class func getCell(tableView:UITableView) -> PlatformTransCell {
        var optionCell: PlatformTransCell?
        optionCell = tableView.dequeueReusableCell(withIdentifier:CellType.Transaction.rawValue) as? PlatformTransCell
        if optionCell == nil {
            optionCell = PlatformTransCell()
        }
        return optionCell!
    }

    func setOption(tag: Int) {
        self.type = tag
        switch tag {
        case 0:
            self.setTransferIn()
            break
        case 1:
            self.setTransferOut()
            break
        case 2:
            self.setGetRebate()
            break
        default:
            break
        }
    }

    fileprivate func setTransferIn() {
        self.lblTitle.text = "Transfer In"
        self.thumbnail.image = UIImage(named: "transfer_in")
    }

    fileprivate func setTransferOut() {
        self.lblTitle.text = "Transfer Out"
        self.thumbnail.image = UIImage(named: "transfer_out")
    }

    fileprivate func setGetRebate() {
        self.lblTitle.text = "Get Rebate"
        self.thumbnail.image = UIImage(named: "get_rebate")
    }
}

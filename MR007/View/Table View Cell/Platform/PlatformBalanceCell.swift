//
//  PlatformBalanceCell.swift
//  MR007
//
//  Created by GreatFeat on 26/05/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

fileprivate enum Image: String {
    case transferIN     = "icon_transfer_in"
    case transferOUt    = "icon_transfer_out"
    case slotGame       = "icon_slot_game"
    case fishGame       = "icon_fish_game"
    case rebate         = "icon_rebate"
}

class PlatformBalanceCell: BaseCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!

    class func getCell(tableView: UITableView, index: IndexPath, platform: String) -> PlatformBalanceCell {
        var platformCell: PlatformBalanceCell?
        platformCell = tableView.dequeueReusableCell(withIdentifier: CellType.PlatformBalance.rawValue, for: index) as? PlatformBalanceCell
        platformCell?.setPlatform(index: index, platform: platform)
        return platformCell!
    }

    private func setPlatform(index: IndexPath, platform: String) {
        switch index.section {
        case 0:
            if index.row == 0 {
                self.thumbnail.image = UIImage(named: Image.transferIN.rawValue)
                self.titleLabel.text = "从主账户转入"
            }

            if index.row == 1 {
                self.thumbnail.image = UIImage(named: Image.transferOUt.rawValue)
                self.titleLabel.text = "转出到主账户"
            }
            self.accessoryType = .disclosureIndicator
            break
        case 1:
            if index.row == 0 {
                self.thumbnail.image = UIImage(named: Image.rebate.rawValue)
                self.titleLabel.text = "领取返水s"
            }
            break
        case 2:
            if index.row == 0 {
                if platform == "SW" || platform == "TTG" || platform == "PT" {
                    self.thumbnail.image = UIImage(named: Image.slotGame.rawValue)
                    //self.titleLabel.text = "启动老虎机游戏"
                    self.titleLabel.text = "启动游戏"
                }
            }

//            if index.row == 1 {
//                self.thumbnail.image = UIImage(named: Image.fishGame.rawValue)
//                self.titleLabel.text = "启动捕鱼游戏"
//            }
            self.accessoryType = .disclosureIndicator
        default:
            break
        }
    }
}

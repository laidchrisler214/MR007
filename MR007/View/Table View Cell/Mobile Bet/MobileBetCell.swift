//
//  MobileBetCell.swift
//  MR007
//
//  Created by Roger Molas on 07/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

fileprivate enum Cell:String {
    case header = "Mobile Bet Header"
    case title = "Mobile Bet Title"
    case custom = "Mobile Bet Custom"
    case image = "Mobile Bet Image"
}

class MobileBetHeaderCell: UITableViewCell {
    static let height:CGFloat = 155.0

    class func getCell(tableView:UITableView) -> MobileBetHeaderCell {
        var cell:MobileBetHeaderCell? = tableView.dequeueReusableCell(withIdentifier: Cell.header.rawValue) as? MobileBetHeaderCell
        if cell == nil {
            cell = MobileBetHeaderCell()
        }
        return cell!
    }
}

class MobileBetTitleCell: UITableViewCell {
    static let height:CGFloat = 50.0

    class func getCell(tableView:UITableView) -> MobileBetTitleCell {
        var cell:MobileBetTitleCell? = tableView.dequeueReusableCell(withIdentifier: Cell.title.rawValue) as? MobileBetTitleCell
        if cell == nil {
            cell = MobileBetTitleCell()
        }
        return cell!
    }
}

class MobileBetCustomCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!

    override func setNeedsLayout() {
        self.maskLayer()
    }

    class func getCell(tableView:UITableView) -> MobileBetCustomCell {
        var cell:MobileBetCustomCell? = tableView.dequeueReusableCell(withIdentifier: Cell.custom.rawValue) as? MobileBetCustomCell
        if cell == nil {
            cell = MobileBetCustomCell()
        }
        return cell!
    }
}

class MobileBetCustomImageCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!

    override func setNeedsLayout() {
        self.maskLayer()
    }

    class func getCell(tableView:UITableView) -> MobileBetCustomImageCell {
        var cell:MobileBetCustomImageCell? = tableView.dequeueReusableCell(withIdentifier: Cell.image.rawValue) as? MobileBetCustomImageCell
        if cell == nil {
            cell = MobileBetCustomImageCell()
        }
        return cell!
    }
}

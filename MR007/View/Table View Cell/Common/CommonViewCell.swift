//
//  CommonViewCell.swift
//  MR007
//
//  Created by Roger Molas on 02/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

// Cell identifier
fileprivate enum Cell:String {
    case Bonus = "Single Button Cell"
}

class SingleButtonCell: UITableViewCell {
    @IBOutlet weak var button:UIButton!

    var mTarget:NSObject? = nil
    var mSelector:Selector? = nil
    var mObject:Any? = nil

    class func getCell(tableView: UITableView) -> SingleButtonCell {
        var bonusCell: SingleButtonCell?
        bonusCell = tableView.dequeueReusableCell(withIdentifier: Cell.Bonus.rawValue) as? SingleButtonCell
        if bonusCell == nil {
            bonusCell = SingleButtonCell()  // Custom action from server
        }
        bonusCell?.isUserInteractionEnabled = true
        return bonusCell!
    }

    func set(target:NSObject, selector:Selector, object:Any) {
        self.mTarget = target
        self.mSelector = selector
        self.mObject = object
    }

    func performSelector() {
        _ = self.mTarget?.perform(self.mSelector, with: self.mObject)
    }
}

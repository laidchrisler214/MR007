//
//  PlatformMenuCell.swift
//  MR007
//
//  Created by Roger Molas on 15/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

class PlatformMenuCell: BaseCollectionCell {
    @IBOutlet weak var lblTitle:UILabel!
    var index:Int = -1
    var menu:String = ""

    class func getCell(collectionView: UICollectionView, indexPath: IndexPath) -> PlatformMenuCell {
        var cell:PlatformMenuCell?
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.Menu.rawValue, for: indexPath) as? PlatformMenuCell
        if cell == nil {
            cell = PlatformMenuCell()
        }
        return cell!
    }

    func setMenu(title:String, index:Int) {
        self.lblTitle.text = title
        self.index = index
        self.menu = title
    }
}

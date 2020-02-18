//
//  SettingsViewCell.swift
//  MR007
//
//  Created by Roger Molas on 06/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

fileprivate enum Cell:Int {
    case Normal = 1
    case Custom = 2
}

class SettingCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var accessoryImage:UIImageView!
}

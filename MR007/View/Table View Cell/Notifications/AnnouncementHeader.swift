//
//  AnnouncementHeader.swift
//  Nirvana
//
//  Created by GreatFeat on 01/08/2017.
//  Copyright © 2017 Greatfeat. All rights reserved.
//

import UIKit

class AnnouncementHeader: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func setCell(announcement: NotificationsModel) {
        dateLabel.text = announcement.updateTime
    }
}

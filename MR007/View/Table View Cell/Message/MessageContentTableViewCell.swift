//
//  MessageContentTableViewCell.swift
//  MR007
//
//  Created by Dwaine Alingarog on 08/12/2016.
//  Copyright © 2016 Greafeat Services Inc. All rights reserved.
//

import UIKit

class MessageContentTableViewCell: BaseCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    class func getCell(tableView: UITableView, idx: IndexPath) -> MessageContentTableViewCell {
        var contentCell: MessageContentTableViewCell?
        contentCell = tableView.dequeueReusableCell(withIdentifier: CellType.Content.rawValue, for:idx) as? MessageContentTableViewCell
        return contentCell!
    }

    func setContent(message: MessageModel) {
        self.titleLabel.text = message.title
        self.descriptionLabel.text = message.contents
    }
}

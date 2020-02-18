//
//  MessageCell.swift
//  MR007
//
//  Created by GreatFeat on 28/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

class MessageCell: BaseCell {

    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var messageTitle: UILabel!
    @IBOutlet weak var messageDetail: UILabel!
    @IBOutlet weak var messageDate: UILabel!

    class func getCell(tableView: UITableView, idx: IndexPath) -> MessageCell {
        var messageCell: MessageCell?
        messageCell = tableView.dequeueReusableCell(withIdentifier: CellType.Message.rawValue, for:idx) as? MessageCell
        return messageCell!
    }

    func setMessage(model: MessageModel) {
        self.messageTitle.text = model.title
        self.messageDetail.text = model.contents
        self.messageDate.text = model.createdTime[0..<10]
        
        if model.status == "1" {
            messageImage.image = #imageLiteral(resourceName: "readMessage")
        } else {
            messageImage.image = #imageLiteral(resourceName: "unreadMessage")
        }
    }
}

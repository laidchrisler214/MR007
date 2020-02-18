//
//  CooperationContentCell.swift
//  MR007
//
//  Created by GreatFeat on 22/12/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

class CooperationContentCell: UITableViewCell {

    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var rowImage: UIImageView!
    @IBOutlet weak var dropIconImageView: UIImageView!
    
    var images = [#imageLiteral(resourceName: "CooperationIcon1"), #imageLiteral(resourceName: "CooperationIcon2"), #imageLiteral(resourceName: "CooperationIcon3"), #imageLiteral(resourceName: "CooperationIcon4")]

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setCell(index: Int, expanded: Bool) {
        rowImage.image = images[index]
        if expanded {
            dropIconImageView.image = #imageLiteral(resourceName: "dropUpIcon")
        } else {
            dropIconImageView.image = #imageLiteral(resourceName: "dropdown")
        }
    }
}

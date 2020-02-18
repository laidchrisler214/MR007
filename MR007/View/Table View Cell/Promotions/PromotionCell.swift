//
//  PromotionCell.swift
//  MR007
//
//  Created by Roger Molas on 07/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

class PromotionCell: UITableViewCell {
    @IBOutlet weak var thumbnail: UIImageView!
    //@IBOutlet weak var bannerTitle: UILabel!
    //@IBOutlet weak var bannerDetail: UILabel!

    func setDetails(bannerModel: BannerPromoModel) {
        let htmlString = bannerModel.bannerUrl
        let encodedHtmlString = htmlString.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        thumbnail.kf.setImage(with: URL(string: encodedHtmlString!))
        //bannerTitle.text = bannerModel.title
        //bannerDetail.text = bannerModel.bannerDetail
    }
}

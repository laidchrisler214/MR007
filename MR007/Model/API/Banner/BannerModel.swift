//
//  BannerModel.swift
//  MR007
//
//  Created by GreatFeat on 07/11/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

//// API Keys
fileprivate enum Keys: String {
    case id            = "id"
    case picUrl        = "picUrl"
    case bannerName    = "bannerName"
    case bannerTitle   = "bannerTitle"
    case bannerDetail  = "bannerDetail"
    case buttonCaption = "buttonCaption"
    case buttonLink    = "buttonLink"
}

class BannerModel: NSObject {
    var id            = 0
    var picUrl        = ""
    var bannerName    = ""
    var bannerTitle   = ""
    var bannerDetail  = ""
    var buttonCaption = ""
    var buttonLink    = ""

    func setBanner(model: NSDictionary) {
        self.id = model[Keys.id.rawValue] as? Int ?? 0
        self.picUrl = model[Keys.picUrl.rawValue] as? String ?? ""
        self.bannerName = model[Keys.bannerName.rawValue] as? String ?? ""
        self.bannerTitle = model[Keys.bannerTitle.rawValue] as? String ?? ""
        self.bannerDetail = model[Keys.bannerDetail.rawValue] as? String ?? ""
        self.buttonCaption = model[Keys.buttonCaption.rawValue] as? String ?? ""
        self.buttonLink = model[Keys.buttonLink.rawValue] as? String ?? ""
    }
}

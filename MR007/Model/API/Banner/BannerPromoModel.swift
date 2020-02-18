//
//  BannerPromoModel.swift
//  MR007
//
//  Created by GreatFeat on 27/12/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

//// API Keys
fileprivate enum Keys: String {
    case id            = "id"
    case categoryId    = "categoryId"
    case category      = "category"
    case content       = "content"
    case bannerUrl     = "bannerUrl"
    case orderNo       = "orderNo"
    case title         = "title"
    case link          = "link"
}

class BannerPromoModel: NSObject {
    var id             = ""
    var categoryId     = ""
    var category       = ""
    var content        = ""
    var bannerUrl      = ""
    var orderNo        = ""
    var title          = ""
    var link           = ""

    func setBanner(model: NSDictionary) {
        self.id = model[Keys.id.rawValue] as? String ?? ""
        self.categoryId = model[Keys.categoryId.rawValue] as? String ?? ""
        self.category = model[Keys.category.rawValue] as? String ?? ""
        self.content = model[Keys.content.rawValue] as? String ?? ""
        self.bannerUrl = model[Keys.bannerUrl.rawValue] as? String ?? ""
        self.orderNo = model[Keys.orderNo.rawValue] as? String ?? ""
        self.title = model[Keys.title.rawValue] as? String ?? ""
        self.link = model[Keys.link.rawValue] as? String ?? ""
    }
}

//
//  BannerRequestManager.swift
//  MR007
//
//  Created by GreatFeat on 07/11/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

fileprivate enum Url: String {
    case banner = "banner"
    case promo = "banner/promo"
}

class BannerRequestManager: APIRequestManager {
    func getBanners(completionHandler: @escaping(_ user: UserModel?, _ banners: [BannerModel]) -> Void, error: RequestErrorBlock?) {
        self.getRequest(completionHandler: { (user, data: NSArray?) in
            var banners = [BannerModel]()
            for object in data! {
                let bannerObject = BannerModel()
                bannerObject.setBanner(model: (object as? NSDictionary)!)
                banners.append(bannerObject)
            }
            completionHandler(user, banners)
        }, error: { (_error) in
            error!(_error)
        }, urlString: Url.banner.rawValue, param: nil, tag: 0)
    }

    func getBannerPromo(completionHandler: @escaping(_ user: UserModel?, _ banners: [BannerPromoModel]) -> Void, error: RequestErrorBlock?) {
        self.getRequest(completionHandler: { (user, data: NSArray?) in
            var banners = [BannerPromoModel]()
            for object in data! {
                let bannerObject = BannerPromoModel()
                bannerObject.setBanner(model: (object as? NSDictionary)!)
                banners.append(bannerObject)
            }
            completionHandler(user, banners)
        }, error: { (_error) in
            error!(_error)
        }, urlString: Url.promo.rawValue, param: nil, tag: 0)
    }
}

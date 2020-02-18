//
//  BasicAuthRequestManager.swift
//  MR007
//
//  Created by GreatFeat on 21/12/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import Alamofire

class BasicAuthRequestManager: NSObject {
    func getPromotionDetailsRequest(completionHandler: @escaping (_ response: [PromotionDetails]) -> Swift.Void,
                                    errorHandler: @escaping (Error) -> Swift.Void) -> Void {
        let urlBuilder = URLBuilder()
        let url = urlBuilder.baseURL + "banner/promo"
        let header = [
            "authorization": "Basic YXBpYWRtaW46Z3JlYXRmZWF0c2VydmljZXM=",
            "cache-control": "no-cache",
            "postman-token": "ca8920cb-cd6f-735f-e752-e0b4d06e9118"
        ]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            var promotionDetails = [PromotionDetails]()
            if let json = response.result.value {
                let data:NSArray? = (json as AnyObject).object(forKey: "data") as? NSArray
                for object in data! {
                    let promoDetailObject = PromotionDetails()
                    promoDetailObject.setBanner(model: (object as? NSDictionary)!)
                    promotionDetails.append(promoDetailObject)
                }
                completionHandler(promotionDetails)
            }
            
            if let error = response.error {
                errorHandler(error)
            }
        }
    }
}

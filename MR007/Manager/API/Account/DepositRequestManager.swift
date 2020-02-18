//
//  DepositRequestManager.swift
//  MR007
//
//  Created by Roger Molas on 23/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import Alamofire

// API
fileprivate enum API: String {
    case method         = "m/deposit/method"
    case existing       = "m/deposit/offline/send"
    case nonExisting    = "m/existing"
    case gateway        = "/m/deposit/gateway/send"
    case category       = "m/deposit/category"
}

class DepositRequestManager: APIRequestManager {
    //Get Deposit Category
    func getDepositCategory(completionHandler: @escaping(_ user:UserModel?, _ category: [DepositCategoryModel]?) -> Void,
                            error: RequestErrorBlock?) {
        self.getRequest(completionHandler: { (user, data: NSArray?) in
            var categories = [DepositCategoryModel]()
            for categoryDict in data! {
                let category = DepositCategoryModel()
                category.setDepositCategory(data: (categoryDict as? NSDictionary)!)
                categories.append(category)
            }
            completionHandler(user, categories)

        }, error: { (_error) in
            error!(_error)

        }, urlString: API.category.rawValue, param: nil, tag: 0)
    }

    /// Get Deposit Method list
    func getDepositGateway(id: String, completionHandler: @escaping(_ user:UserModel?, _ method: DepositMethodModel?) -> Void,
                        error: RequestErrorBlock?) {
        self.getRequest(completionHandler: { (user, data: NSDictionary?) in
            let method = DepositMethodModel()
            method.setMethod(data: data!)
            completionHandler(user, method)
        }, error: { (_error) in
            error!(_error)

        }, urlString: API.method.rawValue, param: ["id":id], tag: 0)
    }

    func getDepositPayway(id: String, completionHandler: @escaping(_ user:UserModel?, _ methods: [DepositMethodModel]?) -> Void,
                           error: RequestErrorBlock?) {
        self.getRequest(completionHandler: { (user, data: NSArray?) in
            var methods = [DepositMethodModel]()
            for methodDict in data! {
                let method = DepositMethodModel()
                method.setMethod(data: (methodDict as? NSDictionary)!)
                methods.append(method)
            }
            completionHandler(user, methods)

        }, error: { (_error) in
            error!(_error)

        }, urlString: API.method.rawValue, param: ["id":id], tag: 0)
    }

    func getDepositList(completionHandler: @escaping(_ user:UserModel?, _ methods: [DepositMethodModel]?) -> Void,
                        error: RequestErrorBlock?) {
        self.getRequest(completionHandler: { (user, data: NSArray?) in
            var methods = [DepositMethodModel]()
            for methodDict in data! {
                let method = DepositMethodModel()
                method.setMethod(data: (methodDict as? NSDictionary)!)
                methods.append(method)
            }
            completionHandler(user, methods)

        }, error: { (_error) in
            error!(_error)

        }, urlString: API.method.rawValue, param: nil, tag: 0)
    }

    /// Send Deposit (Offline by existing banks)
    func sendDepositExistingBank(completionHandler: @escaping(_ user:UserModel?, _ message: String?) -> Void,
                                 error: RequestErrorBlock?,
                                 params: NSDictionary) {
        self.postRequest(completionHandler: { (user, data: NSDictionary?, message) in
            completionHandler(user, message)

        }, error: { (_error) in
            error!(_error)

        }, urlString: API.existing.rawValue, param: params, tag: 0)
    }

    /// Send Deposit (Offline non-existing bank - display form)
    func sendDepositNonExistingBank(completionHandler: @escaping(_ user:UserModel?, _ methods: NSDictionary?) -> Void,
                                    error: RequestErrorBlock?,
                                    params: NSDictionary) {
        self.postRequest(completionHandler: { (user, data: NSDictionary?, message) in
            // Null data handling
            guard data != nil else {
                completionHandler(user, nil)
                return
            }
            completionHandler(user, data!)

        }, error: { (_error) in
            error!(_error)

        }, urlString: API.nonExisting.rawValue, param: params, tag: 0)
    }

    /// Send Deposit (Payment Gateway)
    func sendDepositToGateways(completionHandler: @escaping (_ response: String) -> Swift.Void,
                         errorHandler: @escaping (Error) -> Swift.Void,
                         category: String, amount: String, id: String) -> Void  {
        let token = URLBuilder.getXAuthToken()
        let urlBuilder = URLBuilder()
        let url = urlBuilder.baseURL + "m/deposit/gateway/send?category=\(category)&amount=\(amount)&id=\(id)"
        let header = ["X-AUTH-TOKEN":token]

        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseString { (response) in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                completionHandler(utf8Text)
            }

            if let error = response.error {
                errorHandler(error)
            }
        }
    }
}

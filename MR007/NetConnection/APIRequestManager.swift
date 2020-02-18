//
//  APIRequestManager.swift
//  MR007
//
//  Created by Roger Molas on 23/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

// API Contant Keys
fileprivate enum API: String {
    case user    = "user"
    case data    = "data"
    case message = "message"
}

// APIRequestManager class is a abstract based model of all module Api (e.g accounts, deposit etc.)
class APIRequestManager: APIBaseRequestManager {
    /** POST Request from server */
    func postRequest<T>(completionHandler: @escaping (_ user: UserModel?, _ data: T?, _ message: String?) -> Void,
                     error: RequestErrorBlock?,
                     urlString: String,
                     param: NSDictionary?,
                     tag: Int) {
        self.apiPOSTRequestWith(finished: { (JSONObject) in
            let userIfo: NSDictionary? = JSONObject?.object(forKey: API.user.rawValue) as? NSDictionary
            let data:T? = JSONObject?.object(forKey: API.data.rawValue) as? T
            var message = String()
            if let response: String = JSONObject?.object(forKey: API.message.rawValue) as? String {
                message = response
            }
            let userModel = UserModel()

            // Both Data and User is null
            if data == nil && userIfo == nil && message.isEmpty {
                completionHandler(nil, nil, nil)
                return
            }
            // Message is not null
            if data == nil && userIfo == nil && !message.isEmpty {
                completionHandler(nil, nil, message)
                return
            }
            // Data is null
            if data == nil && userIfo != nil {
                completionHandler(userModel, nil, nil)
                return
            }
            // User is null
            if data != nil && userIfo == nil {
                completionHandler(nil, data, nil)
                return
            }
            userModel.setUser(info: userIfo!)
            completionHandler(userModel, data!, message)

        }, error: { (_error) in
            error!(_error)

        }, urlString: urlString, params: param, tag: tag)
    }

    /** DELETE Request from server */
    func deleteRequest<T>(completionHandler: @escaping (_ user: UserModel?, _ data: T?) -> Void,
                       error: RequestErrorBlock?,
                       urlString: String,
                       param: NSDictionary?,
                       tag: Int) {
        self.apiDELETERequestWith(finished: { (JSONObject) in
            let userIfo: NSDictionary? = JSONObject?.object(forKey: API.user.rawValue) as? NSDictionary
            let data:T? = JSONObject?.object(forKey: API.data.rawValue) as? T
            let userModel = UserModel()

            // Both Data and User is null
            if data == nil && userIfo == nil {
                completionHandler(nil, nil)
                return
            }
            // Data is null
            if data == nil && userIfo != nil {
                completionHandler(userModel, nil)
                return
            }
            // User is null
            if data != nil && userIfo == nil {
                completionHandler(nil, data)
                return
            }
            userModel.setUser(info: userIfo!)
            completionHandler(userModel, data!)

        }, error: { (_error) in
            error!(_error)

        }, urlString: urlString, params: param, tag: tag)
    }

    /** GET Request from server */
    func getRequest<T>(completionHandler: @escaping(_ user: UserModel?, _ data: T?) -> Void,
                    error: RequestErrorBlock?,
                    urlString: String,
                    param: NSDictionary?,
                    tag: Int) {
        self.apiGETRequestWith(finished: { (JSONObject) in
            let userIfo: NSDictionary? = JSONObject?.object(forKey: API.user.rawValue) as? NSDictionary
            let data:T? = JSONObject?.object(forKey: API.data.rawValue) as? T
            let userModel = UserModel()

            // Both Data and User is null
            if data == nil && userIfo == nil {
                completionHandler(nil, nil)
                return
            }
            // Data is null
            if data == nil && userIfo != nil {
                completionHandler(userModel, nil)
                return
            }
            // User is null
            if data != nil && userIfo == nil {
                completionHandler(nil, data)
                return
            }
            userModel.setUser(info: userIfo!)
            completionHandler(userModel, data!)

        }, error: { (_error) in
            error!(_error)

        }, urlString: urlString, params: param, tag: tag)
    }

    func getOnlineDepositRequest<T>(completionHandler: @escaping(_ data: T?) -> Void,
                       error: RequestErrorBlock?,
                       urlString: String,
                       param: NSDictionary?,
                       tag: Int) {
        self.apiGETRequestWith(finished: { (JSONObject) in
            let data = JSONObject as? T
            completionHandler(data)
        }, error: { (_error) in
            error!(_error)
        }, urlString: urlString, params: param, tag: tag)
    }
}

//
//  APIBaseRequestManager.swift
//  MR007
//
//  Created by Roger Molas on 03/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

// Callbacks
typealias RequestFinishedBlock = RequestData
typealias RequestErrorBlock = RequestError

// API Contant Keys
fileprivate enum API: String {
    case success    = "success"
    case message    = "message"
}

class APIBaseRequestManager: NSObject {
    let alertMessage = AlertMessage()
    /** POST Request from server */
    func apiPOSTRequestWith(finished: @escaping RequestFinishedBlock,
                            error: @escaping RequestErrorBlock,
                            urlString: String,
                            params:NSDictionary?,
                            tag: Int) {
        URLRequestManager.sharedManager.generalPOST(completionHandler: { (object) in
            let isSuccess = (object?.object(forKey: API.success.rawValue) as? NSNumber)?.boolValue
            if !isSuccess! {
                self.generalError(title: self.alertMessage.error, message: object?.object(forKey: API.message.rawValue) as? String)
                error(nil)
                return
            }
            /// Tempory Generate custom object
//            if isSuccess! && ((object?[API.message.rawValue]) != nil) {
//                let customObject = NSDictionary(dictionaryLiteral: ("data", object ?? ""))
//                finished(customObject)
//                return
//            }
            finished(object)

        }, errorHandler: { (_error) in
            error(_error)

        }, params: params, urlString: urlString, tag: tag)
    }

    /** POST Request from server */
    func apiDELETERequestWith(finished: @escaping RequestFinishedBlock,
                              error: @escaping RequestErrorBlock,
                              urlString: String,
                              params:NSDictionary?,
                              tag: Int) {
        URLRequestManager.sharedManager.generalDELETE(completionHandler: { (object) in
            let isSuccess = (object?.object(forKey: API.success.rawValue) as? NSNumber)?.boolValue
            if !isSuccess! {
                self.generalError(title: self.alertMessage.error, message: object?.object(forKey: API.message.rawValue) as? String)
                return
            }
            /// Generate data response if data doesn't exist
            if isSuccess! && ((object?[API.message.rawValue]) != nil) {
                let customObject = NSDictionary(dictionaryLiteral: ("data", object ?? ""))
                finished(customObject)
                return
            }
            finished(object)

        }, errorHandler: { (_error) in
            error(_error)

        }, params: params, urlString: urlString, tag: tag)
    }

    /** GET Request from server */
    func apiGETRequestWith(finished: @escaping RequestFinishedBlock,
                           error: @escaping RequestErrorBlock,
                           urlString: String, params: NSDictionary?,
                           tag: Int) {
        URLRequestManager.sharedManager.generalGET(completionHandler: { (object) in
            let isSuccess = (object?.object(forKey: API.success.rawValue) as? NSNumber)?.boolValue
            if !isSuccess! {
                self.generalError(title: self.alertMessage.error, message: object?.object(forKey: API.message.rawValue) as? String)
                return
            }
            /// Generate data response if data doesn't exist
            if isSuccess! && ((object?[API.message.rawValue]) != nil) {
                let customObject = NSDictionary(dictionaryLiteral: ("data", object ?? ""))
                finished(customObject)
                return
            }
            finished(object)

        }, errorHandler: { (_error) in
            error(_error)

        }, params: params, urlString: urlString, tag: tag)
    }

    /// Catch error
    func generalError(title:String?, message:String?) {
        if message != "遊戲響應錯誤！" {
            Alert.with(title: title, message: message)
        }
        print("THE ERROR \(message!)")
    }
}

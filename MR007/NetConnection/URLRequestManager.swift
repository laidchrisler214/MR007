//
//  URLRequestManager.swift
//  MR007
//
//  Created by Roger Molas on 01/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit
import JWT

// Callbacks
typealias RequestData = (NSDictionary?) -> Swift.Void
typealias RequestError = (NSError?) -> Swift.Void

class URLRequestManager: NSObject {
    static let sharedManager: URLRequestManager = URLRequestManager() // Single shared instance
    fileprivate var requestList: NSMutableArray = NSMutableArray() // Holds all request objects

    // MARK: Dealloc objects
    deinit { requestList.removeAllObjects() }

    // MARK: - Public POST request
    public func generalPOST(completionHandler: @escaping RequestData,
                            errorHandler: @escaping RequestError,
                            params: NSDictionary?,
                            urlString: String,
                            tag: Int) {
        if !ReachabilityChecker.isReachable() { // Check network connection
            DispatchQueue.main.async(execute: {
                let app = UIApplication.shared.delegate as? AppDelegate
                app?.showNetworkError()
                LoadingView.hide()
            })
            return
        }

        var request:URLRequest? = nil
        if tag == 0 {
            request = URLBuilder().buildPOSTRequest(api: urlString, params: params)
        } else {
            request = URLBuilder().buildSecurePOSTRequest(api: urlString, params: params)
        }

        let parser = ResponseParser()
        parser.delegate = self
        parser.parseWith(request: request!,
                         completionHandler: completionHandler,
                         errorHandler: errorHandler)
    }

    // MARK: Public DELETE request
    public func generalDELETE(completionHandler: @escaping RequestData,
                              errorHandler: @escaping RequestError,
                              params: NSDictionary?,
                              urlString: String,
                              tag: Int) {
        if !ReachabilityChecker.isReachable() { // Check network connection
            DispatchQueue.main.async(execute: {
                let app = UIApplication.shared.delegate as? AppDelegate
                app?.showNetworkError()
                LoadingView.hide()
            })
            return
        }

        var request:URLRequest? = nil
        request = URLBuilder().buildDELETERequest(api: urlString, params: params)

        let parser = ResponseParser()
        parser.delegate = self
        parser.parseWith(request: request!,
                         completionHandler: completionHandler,
                         errorHandler: errorHandler)
    }

    // MARK: - Public GET request
    public func generalGET(completionHandler: @escaping RequestData,
                           errorHandler: @escaping RequestError,
                           params: NSDictionary?,
                           urlString: String,
                           tag: Int) {
        if !ReachabilityChecker.isReachable() { // Check network connection
            DispatchQueue.main.async(execute: {
                let app = UIApplication.shared.delegate as? AppDelegate
                app?.showNetworkError()
                LoadingView.hide()
            })
        }

        var request:URLRequest? = nil
        request = URLBuilder().buildGETRequest(api: urlString, params: params)

        let parser = ResponseParser()
        parser.delegate = self
        parser.parseWith(request: request!,
                         completionHandler: completionHandler,
                         errorHandler: errorHandler)
    }

    // MARK: Stop all requests
    public func stopAllRequest() {
        requestList.enumerateObjects({ (parser, index, isFinished) in
            (parser as? ResponseParser)?.cancel()
        })
    }
}

// MARK - ResponseParserDelegate
extension URLRequestManager: ResponseParserDelegate {

    internal func responseDidRecievedCustomHeader(_ code: Int, content: String?) {

    }

    internal func responseParserDidfinished(_ parser: ResponseParser) {
        requestList.remove(parser)
    }

    internal func responseParserDidFail(_ parser: ResponseParser, error:Error) {
        requestList.remove(parser)
    }

    internal func responseParserDidCancel(_ parser: ResponseParser) {
        requestList.remove(parser)
    }

    internal func responseDidRecieveStatus(_ code: Int, message: String?) {
        self.stopAllRequest()

        if code == ResponseParserStatus.UnAuthorize.rawValue {
            let sharedUser = SharedUserInfo.sharedInstance
            sharedUser.updateUserInfo(userInfo: nil)
            sharedUser.updateSecurity(data: nil)
            Alert.sessionExpiredAlert()  // Invoke global alert for session
//            let logInRequest = LoginRequestManager()
//            logInRequest.sendLogoutRequest(completionHandler: { (response) in
//                let viewControllerManager:ViewControllerManager = ViewControllerManager.sharedInstance
//                viewControllerManager.showHome()
//            }, error: nil)
        } else if code == ResponseParserStatus.Maintenance.rawValue {
            let delegate = UIApplication.shared.delegate as? AppDelegate
            delegate?.showMaintenanceScreen()

        } else if code == ResponseParserStatus.VersionUpdate.rawValue {
            let delegate = UIApplication.shared.delegate as? AppDelegate
            delegate?.showVersionUpdateScreen(urlString: message!)

        } else if code == ResponseParserStatus.PageNotFound.rawValue {
             Alert.notFoundAlert() // Page Not Found

        } else {
//            print("Unknown Error \(code)")
//            Alert.with(title: "Unknown Error \(code)", message: "Please try again")
        }
    }
}

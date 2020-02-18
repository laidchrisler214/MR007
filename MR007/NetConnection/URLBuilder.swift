//
//  URLBuilder.swift
//  MR007
//
//  Created by Roger Molas on 15/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import JWT

//fileprivate let baseURL = "http://192.168.120.156:9090/mr/api/"
//fileprivate let baseURL = "http://m.mr005.com:9090/mr/api/"

// HTTP Method
fileprivate enum Method: String {
    case GET    = "GET"
    case POST   = "POST"
    case DELETE = "DELETE"
}

// HTTP Request Header
fileprivate enum Header: String {
    case tokenField      = "X-AUTH-TOKEN"
    case contentType     = "Content-Type"
    case contentLength   = "Content-Length"
    case typeJSON        = "application/json"
}

// User Agent Keys
fileprivate enum UserAgent: String {
    case payload            = "payload"
    case app                = "app"
    enum App: String {
        case device         = "device"
        case platform       = "platform"
        case deviceId       = "deviceId"
        case systemVersion  = "systemVersion"
        case deviceModel    = "deviceModel"
        case version        = "version"
    }
    case token              = "token"
    case loginName          = "loginName"  // current user
}

class URLBuilder: NSObject {

//    let baseURL = "http://mr022.cc:8083/mr/api/"
    let baseURL = "http://mobile.tridentinternational.co/api/"

    // MARK: - Build POST Request, body encrypted
    func buildSecurePOSTRequest(api: String, params:NSDictionary?) -> URLRequest? {
        let urlString = baseURL.appending(api)   // Append API string
        var urlRequest:URLRequest? = URLRequest(url: (NSURL(string: urlString) as URL?)!)

        if urlRequest != nil {
            urlRequest?.httpMethod = Method.POST.rawValue
            urlRequest?.setValue(Header.typeJSON.rawValue, forHTTPHeaderField: Header.contentType.rawValue) // Content-Length
            urlRequest?.setValue(userAgent(), forHTTPHeaderField: Header.tokenField.rawValue) // Token Header
            // POST Body
            var POSTBody: NSString = ""
            if params != nil {
                let jwtPayload = JWTManager.encodeJWT(payload: (params! as? Payload)!)
                let token = NSDictionary(dictionary: [UserAgent.token.rawValue : jwtPayload])
                do {
                    let JSONData = try JSONSerialization.data(withJSONObject: token, options: .init(rawValue: 0))
                    POSTBody = NSString(data: JSONData, encoding: String.Encoding.utf8.rawValue)!
                    let lenght = NSNumber(integerLiteral: (POSTBody.length))
                    urlRequest?.setValue(lenght.stringValue, forHTTPHeaderField: Header.contentLength.rawValue)
                    urlRequest?.httpBody = POSTBody.data(using: String.Encoding.utf8.rawValue)
                } catch _ as NSError {
                    return nil
                }
                #if DEBUG
                    print("\nHTTP : Sending POST request : \(urlString)")
                    print("HTTP : Parameters : \(POSTBody)")
                #endif
            }
            return urlRequest
        }
        return nil
    }

    // MARK: - Build POST Request, body not encrypted
    func buildPOSTRequest(api: String, params:NSDictionary?) -> URLRequest? {
        let urlString = baseURL.appending(api)   // Append API string
        var urlRequest:URLRequest? = URLRequest(url: (NSURL(string: urlString) as URL?)!)
        if urlRequest != nil {
            urlRequest?.httpMethod = Method.POST.rawValue
            urlRequest?.setValue(Header.typeJSON.rawValue, forHTTPHeaderField: Header.contentType.rawValue) // Content-Length
            urlRequest?.setValue(userAgent(), forHTTPHeaderField: Header.tokenField.rawValue) // Token Header
            // POST Body
            var POSTBody: NSString = ""
            if params != nil {
                do {
                    let JSONData = try JSONSerialization.data(withJSONObject: params ?? "", options: .init(rawValue: 0))
                    POSTBody = NSString(data: JSONData, encoding: String.Encoding.utf8.rawValue)!
                    let lenght = NSNumber(integerLiteral: (POSTBody.length))
                    urlRequest?.setValue(lenght.stringValue, forHTTPHeaderField: Header.contentLength.rawValue)
                    urlRequest?.httpBody = POSTBody.data(using: String.Encoding.utf8.rawValue)
                } catch _ as NSError {
                    return nil
                }
                #if DEBUG
                    print("\nHTTP : Sending POST request : \(urlString)")
                    print("HTTP : Parameters : \(POSTBody)")
                #endif
            }
            return urlRequest
        }
        return nil
    }

    // MARK: - Build DELETE Request
    func buildDELETERequest(api: String, params:NSDictionary?) -> URLRequest? {
        let urlString = baseURL.appending(api) // Append API string
        var mutableStrings: String = ""
        if params != nil {
            for (index, key) in ((params?.allKeys)?.enumerated())! {
                if index == 0 {
                    let value = encodeValue(fromString: (params?.object(forKey: key) as? String)!)
                    mutableStrings += "?\(key)=\(value!)"
                } else {
                    let value = encodeValue(fromString: (params?.object(forKey: key) as? String)!)
                    mutableStrings += "&\(key)=\(value!)"
                }
            }
        }
        let newURLString = urlString.appending(mutableStrings as String)
        var urlRequest:URLRequest? = URLRequest(url: URL(string: newURLString)!)
        if urlRequest != nil {
            urlRequest?.httpMethod = Method.DELETE.rawValue
            urlRequest?.setValue(Header.typeJSON.rawValue, forHTTPHeaderField: Header.contentType.rawValue)
            urlRequest?.setValue(userAgent(), forHTTPHeaderField: Header.tokenField.rawValue)
            #if DEBUG
                print("\nHTTP : Sending DELETE request : \(urlString)")
                print("HTTP : Parameters : \(mutableStrings)")
            #endif
            return urlRequest
        }
        return nil
    }

    // MARK: - Build GET Request, body encrypted
    func buildGETRequest(api: String, params:NSDictionary?) -> URLRequest? {
        let urlString = baseURL.appending(api) // Append API string
        var mutableStrings: String = ""
        if params != nil {
            for (index, key) in ((params?.allKeys)?.enumerated())! {
                if index == 0 {
                    let value = encodeValue(fromString: (params?.object(forKey: key) as? String)!)
                    mutableStrings += "?\(key)=\(value!)"
                } else {
                    let value = encodeValue(fromString: (params?.object(forKey: key) as? String)!)
                    mutableStrings += "&\(key)=\(value!)"
                }
            }
        }
        let newURLString = urlString.appending(mutableStrings as String)
        var urlRequest:URLRequest? = URLRequest(url: URL(string: newURLString)!)
        if urlRequest != nil {
            urlRequest?.httpMethod = Method.GET.rawValue
            urlRequest?.setValue(Header.typeJSON.rawValue, forHTTPHeaderField: Header.contentType.rawValue)
            urlRequest?.setValue(userAgent(), forHTTPHeaderField: Header.tokenField.rawValue)
            #if DEBUG
                print("\nHTTP : Sending GET request : \(urlString)")
                print("HTTP : Parameters : \(mutableStrings)")
            #endif
            return urlRequest
        }
        return nil
    }

    // MARK: Encode parameters
    private func encodeValue(fromString:String) -> String? {
        let escapedString = fromString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        return escapedString!
    }

    // MARK: Generate User Agent
    private func userAgent() -> String? {
        // e.g. @"iOS"
        let deviceSystemName = UIDevice.current.systemName
        // e.g. @"E621E1F8-C36C-495A-93FC-0C247A3E6E5F""
        let deviceId = NSUUID().uuidString
        // e.g. @"10.0"
        let deviceSystemVersion = UIDevice.current.systemVersion
        // e.g. iPhone, iPad, iPod touch
        let deviceModel = UIDevice.current.model
        // app version
        let appVersion = Bundle.main.infoDictionary?["CFBusndleShortVersionString"] as? String
        // Token
        let savedToken = SharedUserInfo.sharedInstance.getToken()// tmp will change to keychain after
        // Current log on user

        let currentUser = SharedUserInfo.sharedInstance.getUserName()
        let app = [UserAgent.App.platform.rawValue:deviceSystemName,
                   UserAgent.App.deviceId.rawValue: deviceId,
                   UserAgent.App.systemVersion.rawValue:deviceSystemVersion,
                   UserAgent.App.deviceModel.rawValue:deviceModel,
                   UserAgent.App.version.rawValue:appVersion ?? "1.0"] as [String : Any]

        let payload = [UserAgent.app.rawValue:app,
                       UserAgent.loginName.rawValue: currentUser,
                       UserAgent.token.rawValue: savedToken] as [String : Any]
        #if DEBUG
            print("HTTP Secure Payload: \(JWTManager.encodeJWT(payload: payload))")
        #endif
        return JWTManager.encodeJWT(payload: payload)
    }

    /// External request parameter
    class func getXAuthToken () -> String {
        let builder = URLBuilder()
        return builder.userAgent()!
    }
}

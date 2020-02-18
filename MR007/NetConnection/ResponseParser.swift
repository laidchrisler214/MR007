//
//  ResponseParser.swift
//  MR007
//
//  Created by Roger Molas on 30/01/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

protocol ResponseParserDelegate: NSObjectProtocol {
    func responseParserDidfinished(_ parser: ResponseParser)
    func responseParserDidFail(_ parser: ResponseParser, error:Error)
    func responseParserDidCancel(_ parser: ResponseParser)
    func responseDidRecieveStatus(_ code: Int, message: String?)
    func responseDidRecievedCustomHeader(_ code: Int, content: String?)
}

public enum ParserDomain: String {
    case Parsing =  "Parsing Error"
    case Response = "Response Error"
}

public enum ParserErrorCode: Int {
    case Parsing    = 501
    case Response   = 502
}

public enum ResponseParserStatus: Int {
    case Live           = 200
    case UnAuthorize    = 401
    case VersionUpdate  = 403
    case Maintenance    = 204
    case GameNotFound   = 400
    case PageNotFound   = 404
}

class ResponseParser : NSObject {
    weak open var delegate: ResponseParserDelegate? = nil
    public var isCancel = false
    public var isError = false

    fileprivate var task: URLSessionDataTask? = nil
    fileprivate var receiveData: NSMutableData? = nil
    fileprivate var currentStatus: Int = 0
    fileprivate var mDataHandler: ((NSDictionary) -> Swift.Void?)? = nil
    fileprivate var mErrorHandler: ((NSError?) -> Swift.Void?)? = nil

    public func parseWith(request: URLRequest,
                   completionHandler: @escaping (NSDictionary) -> Swift.Void,
                   errorHandler: @escaping (NSError?) -> Swift.Void) {
        mDataHandler = nil
        mErrorHandler = nil

        // Reference Callbacks
        mDataHandler = completionHandler
        mErrorHandler = errorHandler

        // Session configuration
        var session = URLSession.shared
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.allowsCellularAccess = true // use cellular data
        sessionConfig.timeoutIntervalForRequest = 30.0 // timeout per request
        sessionConfig.timeoutIntervalForResource = 30.0 // timeout per resource access
        sessionConfig.httpMaximumConnectionsPerHost = 1 // connection per host
        session = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: OperationQueue.main)
        task = session.dataTask(with: request)
        task?.resume()
    }

    // MARK: Life cycle
    deinit {
        mDataHandler = nil
        mErrorHandler = nil
    }

    // MARK: Suppend task operations
    public func suspend() {
        task?.suspend()
    }

    // MARK: Cancel task operations
    public func cancel() {
        task?.cancel()
        task = nil
        receiveData = nil
        isCancel = true
        self.delegate?.responseParserDidCancel(self)
    }

    fileprivate func thowErrorException(error: NSError) {
        self.isError = true
        if mErrorHandler != nil {
            self.mErrorHandler!(error)
        }
        self.delegate?.responseParserDidFail(self, error: error)
    }

    fileprivate func responseError() -> NSError {
        return NSError(domain: ParserDomain.Response.rawValue,
                       code: ParserErrorCode.Response.rawValue,
                       userInfo: nil)
    }

    fileprivate func parsingError() -> NSError {
        return NSError(domain: ParserDomain.Parsing.rawValue,
                       code: ParserErrorCode.Parsing.rawValue,
                       userInfo: nil)
    }

    /// MARK: Unit Test
    public func parseTestWith(data: NSData,
                              completionHandler: @escaping (NSDictionary) -> Swift.Void,
                              errorHandler: @escaping (NSError?) -> Swift.Void) {
        var parsedData:Any? = nil
        do {
            parsedData = try JSONSerialization.jsonObject(with: data as Data, options:.allowFragments)
            guard parsedData != nil else {
                self.thowErrorException(error: self.parsingError())
                return
            }
            completionHandler((parsedData as? NSDictionary)!)

        } catch _ as NSError {
            self.thowErrorException(error: self.parsingError())
        }
    }

    public func parseTestResponceCode(response:HTTPURLResponse, completionHandler: @escaping (Int) -> Swift.Void) {
        let status = response.statusCode
        if status == ResponseParserStatus.UnAuthorize.rawValue {
            delegate?.responseDidRecieveStatus(ResponseParserStatus.UnAuthorize.rawValue, message: nil)
            completionHandler(ResponseParserStatus.UnAuthorize.rawValue)

        } else if status == ResponseParserStatus.Maintenance.rawValue {
            delegate?.responseDidRecieveStatus(ResponseParserStatus.Maintenance.rawValue, message: nil)
            completionHandler(ResponseParserStatus.Maintenance.rawValue)

        } else if status == ResponseParserStatus.VersionUpdate.rawValue {
            delegate?.responseDidRecieveStatus(ResponseParserStatus.VersionUpdate.rawValue, message: nil)
            completionHandler(ResponseParserStatus.VersionUpdate.rawValue)

        } else if status == ResponseParserStatus.Live.rawValue {
            completionHandler(ResponseParserStatus.Live.rawValue)

        } else if status == ResponseParserStatus.GameNotFound.rawValue {
            completionHandler(ResponseParserStatus.GameNotFound.rawValue)

        } else if status == ResponseParserStatus.PageNotFound.rawValue {
            completionHandler(ResponseParserStatus.PageNotFound.rawValue)

        } else {
            delegate?.responseDidRecieveStatus(status, message: nil)
            completionHandler(status)
        }
    }
}

// MARK - URLSessionDataDelegate
extension ResponseParser: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        receiveData?.append(data)
    }

    // MARK: Start recieving response
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        let response = response as? HTTPURLResponse
        let status = response?.statusCode
        self.currentStatus = status!

        if status == ResponseParserStatus.UnAuthorize.rawValue {
            delegate?.responseDidRecieveStatus(ResponseParserStatus.UnAuthorize.rawValue, message: nil)
            completionHandler(.cancel)
        } else if status == ResponseParserStatus.Maintenance.rawValue {
            delegate?.responseDidRecieveStatus(ResponseParserStatus.Maintenance.rawValue, message: nil)
            completionHandler(.cancel)

        } else if status == ResponseParserStatus.VersionUpdate.rawValue {
            let link = response?.allHeaderFields["url"] as? String ?? ""
            delegate?.responseDidRecieveStatus(ResponseParserStatus.VersionUpdate.rawValue, message: link)
            completionHandler(.cancel)

        } else if status == ResponseParserStatus.Live.rawValue {
            if receiveData != nil { receiveData = nil }
            receiveData = NSMutableData()
            receiveData?.length = 0
            #if DEBUG
                print("\nHTTP: Response Headers: \(String(describing: response?.allHeaderFields))")
            #endif
            completionHandler(.allow)

        } else if status == ResponseParserStatus.GameNotFound.rawValue {
            completionHandler(.cancel)
            delegate?.responseDidRecieveStatus(ResponseParserStatus.GameNotFound.rawValue, message: nil)

        } else if status == ResponseParserStatus.PageNotFound.rawValue {
            delegate?.responseDidRecieveStatus(ResponseParserStatus.PageNotFound.rawValue, message: nil)

        } else {
            delegate?.responseDidRecieveStatus(status!, message: nil)
            completionHandler(.cancel)
        }
    }
}

// MARK - URLSessionTaskDelegate
extension ResponseParser: URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {

        guard error == nil else {
            self.thowErrorException(error: (error as NSError?)!)
            return
        }

        guard currentStatus == ResponseParserStatus.Live.rawValue else {
            return
        }

        var parsedData: AnyObject? = nil
        /** Spawn serialization task to background thread */
        let backgoundQueue = DispatchQueue(label: "com.parse.data")
        backgoundQueue.async {
            do {
                parsedData = try JSONSerialization.jsonObject(with: self.receiveData! as Data, options:.allowFragments) as? NSDictionary
                if parsedData == nil {
                    parsedData = try JSONSerialization.jsonObject(with: self.receiveData! as Data, options:.allowFragments) as AnyObject
                }
                /** Spawn output to main queue */
                DispatchQueue.main.async {
                    guard parsedData != nil else {
                        self.thowErrorException(error: self.parsingError())
                        return
                    }
                    #if DEBUG
                        print("\nHTTP Response from server :\n \(parsedData!)")
                    #endif
                    self.mDataHandler!((parsedData! as? NSDictionary)!)
                    self.delegate?.responseParserDidfinished(self)
                }
            } catch _ as NSError {
                self.thowErrorException(error: self.parsingError())
            }
        }
    }
}

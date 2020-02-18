//
//  ResponseParser.swift
//  MR007
//
//  Created by Roger Molas on 10/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

@testable import MR007
import Foundation
import XCTest

class ResponseParserTest: XCTestCase {

    let testUrl = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22nome%2C%20ak%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"

    let JString: String = "{\"success\":\"1\",\"error\":\"0\",\"message\":\"Test message\",\"user\": {\"name\":\"greatfeat\",\"device\": \"iOS\"}}"
    var jsonData:NSData? = nil
    let jsonDataInvalid:NSData? = "string".data(using: .utf8) as NSData?

    var url: URL!
    var request: URLRequest!

    fileprivate var mDataHandler:((NSDictionary) -> Swift.Void?)? = nil
    fileprivate var mErrorHandler:((NSError?) -> Swift.Void?)? = nil
    fileprivate var mCancelHandler:((Swift.Void) -> Swift.Void?)? = nil

    override func setUp() {
        super.setUp()
        url = URL(string: testUrl)
        request = URLRequest(url: url)
        jsonData = JString.data(using: .utf8) as NSData?
    }

    override func tearDown() {
        XCTAssertNil(mDataHandler, "Release Completion Callback")
        XCTAssertNil(mErrorHandler, "Release Error Callback")
        XCTAssertNil(mCancelHandler, "Release Cancelation Callback")
        super.tearDown()
    }

    func testParserValidURL() {
        XCTAssertTrue(request != nil)
    }

    func testResponseParsing() {
        let parser = ResponseParser()
        parser.delegate = self
        parser.parseTestWith(data: jsonData!, completionHandler: { (data) in
            XCTAssertNotNil(data, "Data should not be nil")
            XCTAssertTrue(data.allKeys.count > 0)
            XCTAssertTrue(data.isKind(of: NSDictionary.self))

        }) { (error) in
            XCTFail("Not expecting error here")
        }
    }

    func testResponseParsingError() {
        let parser = ResponseParser()
        parser.delegate = self
        parser.parseTestWith(data: jsonDataInvalid!, completionHandler: { (data) in
            XCTAssertNil(data, "Data should be nil")
            XCTFail("Not expecting results here")

        }) { (error) in
            XCTAssertNotNil(error, "Error should not be nil")
            XCTAssertTrue((error?.isKind(of: NSError.self))!)
            XCTAssertEqual(error?.code, ParserErrorCode.Parsing.rawValue)
            XCTAssertEqual(error?.domain, ParserDomain.Parsing.rawValue)
        }
    }

    // MARK: Parser testing itself
    func testParserCancelation() {
        let parser = ResponseParser()
        parser.delegate = self
        parser.cancel()
        XCTAssertTrue(parser.isCancel)
    }

    func testResponseCodeMaintenace() {
        let parser = ResponseParser()
        let response = HTTPURLResponse(url: url, statusCode: ResponseParserStatus.Maintenance.rawValue, httpVersion: "HTTP/1.1", headerFields: ["userAgent":"greatFeat"])!
        parser.parseTestResponceCode(response: response) { (status) in
            XCTAssertEqual(status, ResponseParserStatus.Maintenance.rawValue)
        }
    }

    func testResponseCodeVersionUpdate() {
        let parser = ResponseParser()
        let response = HTTPURLResponse(url: url, statusCode: ResponseParserStatus.VersionUpdate.rawValue, httpVersion: "HTTP/1.1", headerFields: ["userAgent":"greatFeat"])!
        parser.parseTestResponceCode(response: response) { (status) in
            XCTAssertEqual(status, ResponseParserStatus.VersionUpdate.rawValue)
        }
    }

    private func httpURLResponse(forStatusCode statusCode: Int, headers:[String : String]?) -> HTTPURLResponse {
        return HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: "HTTP/1.1", headerFields: headers)!
    }
}

extension ResponseParserTest: ResponseParserDelegate {
    func responseParserDidfinished(_ parser: ResponseParser) {
        XCTAssertNotNil(parser, "Parser should not be nil when finished")
    }

    func responseParserDidFail(_ parser: ResponseParser, error:Error) {
        XCTAssertNotNil(parser, "Parser should not be nil when error occured")
        XCTAssertNotNil(error, "Error should not be nil when parser failed")
    }

    func responseParserDidCancel(_ parser: ResponseParser) {
        XCTAssertNotNil(parser, "Parser should not be nil on cancelation")
    }

    func responseDidRecieveStatus(_ code: Int, message: String?) {

    }
}

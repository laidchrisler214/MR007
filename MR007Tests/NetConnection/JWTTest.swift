//
//  JWTTest.swift
//  MR007
//
//  Created by Roger Molas on 08/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

@testable import MR007

import Foundation
import XCTest

typealias Payload = [String: Any]

class JWTTest: XCTestCase {
    let secretKey: String = "9mIl-RXG931vkzh7im6JXMd2QC5OlazFoJogkKPIcaAXUUmz0b-N8engAm2LFLYh"
    let expected: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJHcmVhdCBGZWF0IjoiU2VydmljZXMifQ.RHX68RuwmT9URvro4b8hDlt3IUJ3rNhNUZ5GUjCCPXs"
    let payload: Payload = ["Great Feat": "Services"]

    var toEncoded: String!
    var toDecoded: Payload!

    override func setUp() {
        super.setUp()
    }

    func testBasicEncodingDecoding() {
        toEncoded = JWTManager.encodeJWT(payload: payload) // Test encoding
        toDecoded = JWTManager.decodeJWT(string: expected) // Test decoding
    }
}

// MARK: Encoding
class JWTEncodingTest: JWTTest {

    func testEncodingEntry() {
        let jwt = JWTManager.encodeJWT(payload: payload) // Test encoding
        XCTAssertTrue(expected.contains(jwt))
    }

    func testEncodingPayload() {
        let jwt = JWTManager.encodeJWT(payload: payload)
        XCTAssertEqual(jwt, expected)
    }

    func testEncodingHS256() {
        let data = secretKey.data(using: .utf8)!
        let jwt = JWTManager.encode(payload: payload, algorithm: .hs256(data))
        XCTAssertTrue(expected.contains(jwt))
    }
}

// MARK: Decoding
class JWTDecodingTest: JWTTest {

    func testDecodingEntry() throws {
        let result = JWTManager.decodeJWT(string: self.expected)
        XCTAssertEqual(result["Great Feat"] as? String, "Services")
    }

    func testDecodingPayload() {
        let jwt = JWTManager.decodeJWT(string: expected)
        XCTAssertEqual((jwt as? [String: String])!, ["Great Feat": "Services"])
    }

    func testDecodingHS256() {
        let data = secretKey.data(using: .utf8)!
        let jwt = JWTManager.decode(string: expected, algorithm: .hs256(data))
        XCTAssertEqual((jwt as? [String: String])!, ["Great Feat": "Services"])
    }
}

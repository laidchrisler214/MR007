//
//  PlatformTests.swift
//  MR007
//
//  Created by Dwaine Alingarog on 12/12/2016.
//  Copyright © 2016 Greafeat Services Inc. All rights reserved.
//

import XCTest
@testable import MR007

class PlatformTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInit_ShouldTakeRequiredParameters() {
        let platform = Platform(platformId: 5, name: "Dwaine", details: "Details", type: .agFisher)
        XCTAssertEqual(platform.platformId, 5)
        XCTAssertEqual(platform.name, "Dwaine")
        XCTAssertEqual(platform.details, "Details")
        XCTAssertEqual(platform.type, .agFisher)
    }

    func testInit_ShouldTakeURLPhoto() {
        let platform = Platform(platformId: 5, urlPhoto: "url", name: "Dwaine", details: "Details", type: .slotMachine)
        XCTAssertEqual(platform.platformId, 5)
        XCTAssertEqual(platform.urlPhoto, "url")
        XCTAssertEqual(platform.name, "Dwaine")
        XCTAssertEqual(platform.details, "Details")
        XCTAssertEqual(platform.type, .slotMachine)
    }
}

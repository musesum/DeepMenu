//
//  MuSpokeTests.swift
//  DeepMenuTests
//
//  Created by Dav Yaginuma on 2/16/22.
//

import XCTest
@testable import DeepMenu

class MuSpokeTests: XCTestCase {
    var hub: MuHub!
    var dock1: MuDock!

    override func setUpWithError() throws {
        hub = MuHub([.lower, .right])
        dock1 = MuDock(axis: .horizontal)
    }

    override func tearDownWithError() throws {
    }

    func testInit() throws {
        let spoke = MuSpoke(docks: [dock1], hub: hub)
        XCTAssertNotNil(spoke)
        XCTAssertEqual(1, spoke.docks.count)
    }
}

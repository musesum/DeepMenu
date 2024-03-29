//
//  MuNodeModelTests.swift
//  DeepMenuTests
//
//  Created by Dav Yaginuma on 2/21/22.
//

import XCTest

@testable import DeepMenu

class MuNodeModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInit_withOnlyName() throws {
        let sut = MuCornerNode("TEST")
        XCTAssertEqual("TEST", sut.name)
        XCTAssertEqual(.node, sut.nodeType)
        XCTAssertEqual("TEST", sut.title)
    }

    func testInit_withSelectionCallback() throws {
        var callbackRan = false
        let sut = MuCornerNode("TEST") { _ in callbackRan = true }
        XCTAssertEqual("TEST", sut.name)
        XCTAssertEqual(MuNodeType.node, sut.nodeType)
        XCTAssertEqual("TEST", sut.title)
        XCTAssert(callbackRan == false)
        sut.callback("Something")
        XCTAssert(callbackRan == true)
    }

    func test_addChild() throws {
        let sut = MuCornerNode("Parent")
        let child = MuCornerNode("Child")
        
        sut.addChild(child)

        XCTAssertEqual([child], sut.children)
        XCTAssertEqual(sut, child.parent)
    }
}

//
//  MuPodModelTests.swift
//  DeepMenuTests
//
//  Created by Dav Yaginuma on 2/21/22.
//

import XCTest

@testable import DeepMenu

class MuPodModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInit_withOnlyName() throws {
        let sut = MuPodModel("TEST")
        XCTAssertEqual("TEST", sut.name)
        XCTAssertEqual(.pod, sut.borderType)
        XCTAssertEqual("TEST", sut.title)
    }

    func testInit_withSelectionCallback() throws {
        var callbackRan = false
        let sut = MuPodModel("TEST") { _ in callbackRan = true }
        XCTAssertEqual("TEST", sut.name)
        XCTAssertEqual(MuBorderType.pod, sut.borderType)
        XCTAssertEqual("TEST", sut.title)
        XCTAssert(callbackRan == false)
        sut.callback("Something")
        XCTAssert(callbackRan == true)
    }

    func test_addChild() throws {
        let sut = MuPodModel("Parent")
        let child = MuPodModel("Child")
        
        sut.addChild(child)

        XCTAssertEqual([child], sut.subModels)
        XCTAssertEqual(sut, child.parent)
    }
}

//
//  MuLimbTests.swift
//  DeepMenuTests
//
//  Created by Dav Yaginuma on 2/16/22.
//

import XCTest
@testable import DeepMenu

class MuLimbTests: XCTestCase {
    var root: MuRootVm!
    var branch1: MuBranchVm!

    override func setUpWithError() throws {
        root = MuRootVm([.lower, .right], branches: nil)
        branch1 = MuBranchVm(axis: .horizontal)
    }

    override func tearDownWithError() throws {
    }

    func testInit() throws {
        let limb = MuLimbVm(branches: [branch1], root: root)
        XCTAssertNotNil(limb)
        XCTAssertEqual(1, limb.branches.count)
    }

    func testObservableAndBranchesPublished() throws {
        let limb = MuLimbVm(branches: [branch1], root: root)
        
        // This won't compile if not observable and published
        let _ = limb.$branches.sink(receiveValue: { print("ViewModel.branches updated, new value: \($0)") })
        let _ = limb.objectWillChange.sink(receiveValue: { print("ViewModel updated: \($0)")})
    }
}

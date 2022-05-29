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
    var tree: MuTreeVm!
    var branch1: MuBranchVm!

    override func setUpWithError() throws {
        root = MuRootVm([.lower, .right], axii: [.vertical])
        tree = root.treeNowVm
        branch1 = MuBranchVm(tree)
    }

    override func tearDownWithError() throws {
    }

    func testInit() throws {
        let tree = MuTreeVm(branches: [branch1], axis: .vertical, root: root)
        XCTAssertNotNil(tree)
        XCTAssertEqual(1, tree.branches.count)
    }

    func testObservableAndBranchesPublished() throws {
        let tree = MuTreeVm(branches: [branch1], root: root)
        
        // This won't compile if not observable and published
        let _ = tree.$branches.sink(receiveValue: { print("ViewModel.branches updated, new value: \($0)") })
        let _ = tree.objectWillChange.sink(receiveValue: { print("ViewModel updated: \($0)")})
    }
}

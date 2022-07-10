//
//  MuLimbViewTests.swift
//  DeepMenuTests
//
//  Created by Dav Yaginuma on 2/17/22.
//

import XCTest
import ViewInspector
import SwiftUI

@testable import DeepMenu

extension MuTreeView: Inspectable { }

class MuTreeViewTests: XCTestCase {
    let rootLowerRight = MuRootVm([.lower, .right], branches: nil)
    let rootLowerLeft = MuRootVm([.lower, .left ], branches: nil)
    let rootUpperRight = MuRootVm([.upper, .right], branches: nil)
    let rootUpperLeft = MuRootVm([.upper, .left ], branches: nil)

    let horizontalBranch = MuBranchVm(axis: .horizontal)
    let verticalBranch = MuBranchVm(axis: .vertical)

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testLayoutRelativeToRootPlacement() throws {
        let horizontalLowerRightLimb = MuTreeVm(branches: [horizontalBranch], root: rootLowerRight)
        var treeView = MuTreeView(treeVm: horizontalLowerRightLimb).environmentObject(rootLowerRight)
        var vStackView = try treeView.inspect().view(MuTreeView.self).vStack()
        XCTAssertEqual(HorizontalAlignment.trailing, try vStackView.alignment())

        let horizontalLowerLeftLimb = MuTreeVm(branches: [horizontalBranch],
                                               root: rootLowerLeft)
        treeView = MuTreeView(treeVm: horizontalLowerLeftLimb) .environmentObject(rootLowerLeft)
        vStackView = try treeView.inspect().view(MuTreeView.self).vStack()
        XCTAssertEqual(HorizontalAlignment.leading, try vStackView.alignment())
    }
}

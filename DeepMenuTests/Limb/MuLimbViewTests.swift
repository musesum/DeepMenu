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

extension MuLimbView: Inspectable { }

class MuLimbViewTests: XCTestCase {
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
        let horizontalLowerRightLimb = MuLimbVm(branches: [horizontalBranch], root: rootLowerRight)
        var limbView = MuLimbView(limb: horizontalLowerRightLimb).environmentObject(rootLowerRight)
        var vStackView = try limbView.inspect().view(MuLimbView.self).vStack()
        XCTAssertEqual(HorizontalAlignment.trailing, try vStackView.alignment())

        let horizontalLowerLeftLimb = MuLimbVm(branches: [horizontalBranch], root: rootLowerLeft)
        limbView = MuLimbView(limb: horizontalLowerLeftLimb).environmentObject(rootLowerLeft)
        vStackView = try limbView.inspect().view(MuLimbView.self).vStack()
        XCTAssertEqual(HorizontalAlignment.leading, try vStackView.alignment())
    }
}

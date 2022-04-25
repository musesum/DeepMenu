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
    let hubLowerRight = MuRoot([.lower, .right], branches: nil)
    let hubLowerLeft = MuRoot([.lower, .left ], branches: nil)
    let hubUpperRight = MuRoot([.upper, .right], branches: nil)
    let hubUpperLeft = MuRoot([.upper, .left ], branches: nil)

    let horizontalBranch = MuBranch(axis: .horizontal)
    let verticalBranch = MuBranch(axis: .vertical)

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testLayoutRelativeToRootPlacement() throws {
        let horizontalLowerRightLimb = MuLimb(branches: [horizontalBranch], root: hubLowerRight)
        var limbView = MuLimbView(limb: horizontalLowerRightLimb).environmentObject(hubLowerRight)
        var vStackView = try limbView.inspect().view(MuLimbView.self).vStack()
        XCTAssertEqual(HorizontalAlignment.trailing, try vStackView.alignment())

        let horizontalLowerLeftLimb = MuLimb(branches: [horizontalBranch], root: hubLowerLeft)
        limbView = MuLimbView(limb: horizontalLowerLeftLimb).environmentObject(hubLowerLeft)
        vStackView = try limbView.inspect().view(MuLimbView.self).vStack()
        XCTAssertEqual(HorizontalAlignment.leading, try vStackView.alignment())
    }
}

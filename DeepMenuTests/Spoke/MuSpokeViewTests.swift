//
//  MuSpokeViewTests.swift
//  DeepMenuTests
//
//  Created by Dav Yaginuma on 2/17/22.
//

import XCTest
import ViewInspector
import SwiftUI

@testable import DeepMenu

extension MuSpokeView: Inspectable { }

class MuSpokeViewTests: XCTestCase {
    let hubLowerRight = MuHub([.lower, .right], docks: nil)
    let hubLowerLeft = MuHub([.lower, .left ], docks: nil)
    let hubUpperRight = MuHub([.upper, .right], docks: nil)
    let hubUpperLeft = MuHub([.upper, .left ], docks: nil)

    let horizontalDock = MuDock(axis: .horizontal)
    let verticalDock = MuDock(axis: .vertical)

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testLayoutRelativeToHubPlacement() throws {
        let horizontalLowerRightSpoke = MuSpoke(docks: [horizontalDock], hub: hubLowerRight)
        var spokeView = MuSpokeView(spoke: horizontalLowerRightSpoke).environmentObject(hubLowerRight)
        var vStackView = try spokeView.inspect().view(MuSpokeView.self).vStack()
        XCTAssertEqual(HorizontalAlignment.trailing, try vStackView.alignment())

        let horizontalLowerLeftSpoke = MuSpoke(docks: [horizontalDock], hub: hubLowerLeft)
        spokeView = MuSpokeView(spoke: horizontalLowerLeftSpoke).environmentObject(hubLowerLeft)
        vStackView = try spokeView.inspect().view(MuSpokeView.self).vStack()
        XCTAssertEqual(HorizontalAlignment.leading, try vStackView.alignment())
    }
}

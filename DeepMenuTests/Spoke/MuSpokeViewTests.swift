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
    let hubLowerRight = MuHub([.lower, .right])
    let hubLowerLeft = MuHub([.lower, .left ])
    let hubUpperRight = MuHub([.upper, .right])
    let hubUpperLeft = MuHub([.upper, .left ])

    let horizonalDock = MuDock(axis: .horizontal)
    let verticalDock = MuDock(axis: .vertical)

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testLayoutRelativeToHubPlacement() throws {
        let horizontalLowerRightSpoke = MuSpoke(docks: [horizonalDock], hub: hubLowerRight)

        var spokeView = MuSpokeView(spoke: horizontalLowerRightSpoke).environmentObject(hubLowerRight)
        var vStackView = try spokeView.inspect().view(MuSpokeView.self).vStack()
        XCTAssertEqual(HorizontalAlignment.trailing, try vStackView.alignment())

        let horizontalLowerLeftSpoke = MuSpoke(docks: [horizonalDock], hub: hubLowerLeft)
        spokeView = MuSpokeView(spoke: horizontalLowerLeftSpoke).environmentObject(hubLowerLeft)
        vStackView = try spokeView.inspect().view(MuSpokeView.self).vStack()
        XCTAssertEqual(HorizontalAlignment.leading, try vStackView.alignment())
    }
}

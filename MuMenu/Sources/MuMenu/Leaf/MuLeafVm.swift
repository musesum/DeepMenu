//  Created by warren on 6/21/22.

import SwiftUI

/// MuLeaf* Model and View  protocols
public protocol MuLeafProxy {

    /// update value from user touch gesture
    func touchLeaf(_ touchState: MuTouchState)

    /// update from model, not touch gesture
    func updateLeaf(_ point: Any)

    /// refresh View from current thumb
    func updateView()

    /// title for control value
    func valueText() -> String

    /// position of thumb in control
    func thumbOffset() -> CGSize
}

/// extend MuNodeVm to show title and thumb position
public class MuLeafVm: MuNodeVm {

    /// updated textual title of control value
    @objc dynamic func valueText() -> String {
        print("*** override MuLeafVm.status")
        return "oops"
    }

    /// updated position of thumb inside control
    @objc dynamic func thumbOffset() -> CGSize {
        print("*** override MuLeafVmoffset")
        return .zero
    }

    /// bounds for control surface, used to determin if touch is inside control area
    var runwayBounds = CGRect.zero

    /// updated by View after auto-layout
    func updateRunwayBounds(_ bounds: CGRect) {
        runwayBounds = bounds
        // log("runwayBounds", [runwayBounds], terminator: " ")
    }
    /// does control surface contain point
    override func contains(_ point: CGPoint) -> Bool {
        return runwayBounds.contains(point)
    }
}

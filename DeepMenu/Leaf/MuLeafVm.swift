//  Created by warren on 6/21/22.

import SwiftUI

/// leaf Model setter protocol
public protocol MuLeafModelProtocol {

    /// update value from user gesture
    func touchLeaf(_ point: CGPoint)

    /// update value from another model
    func updateLeaf(_ point: Any)
}

/// leaf View protocol
public protocol MuLeafViewProtocol {

    /// title for control value
    func valueText() -> String

    /// position of thumb in control
    func thumbOffset() -> CGSize
}

/// extend MuNodeVm to show title and thumb position
class MuLeafVm: MuNodeVm {

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
}

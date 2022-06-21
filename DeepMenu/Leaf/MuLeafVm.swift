//  Created by warren on 6/21/22.

import SwiftUI

public protocol MuLeafModelProtocol {

    /// update from user interaction
    func touchLeaf(_ point: CGPoint)

    /// update from model
    func updateLeaf(_ point: Any)
}

public protocol MuLeafViewProtocol {

    /// updated text for control
    func status() -> String

    /// position of thumb in control
    func offset() -> CGSize
}

class MuLeafVm: MuNodeVm {

    /// updated textual title of control value
    @objc dynamic func status() -> String {
        print("*** override MuLeafVm.status")
        return "oops"
    }

    /// updated position of thumb inside control
    @objc dynamic func offset() -> CGSize {
        print("*** override MuLeafVmoffset")
        return .zero
    }
}

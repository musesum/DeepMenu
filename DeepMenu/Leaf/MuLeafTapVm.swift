//  Created by warren on 5/10/22.

import SwiftUI

/// tap control
class MuLeafTapVm: MuLeafVm {

    var proto: MuNodeProtocol?

    init (_ node: MuNode,
          _ branchVm: MuBranchVm,
          _ prevVm: MuNodeVm?,
          icon: String = "") {
        
        super.init(.tap, node, branchVm, prevVm, icon: icon)
        node.leaves.append(self) // MuLeaf delegate for setting value
        proto = node.proto ?? prevVm?.node.proto
    }
}
// Model
extension MuLeafTapVm: MuLeafModelProtocol {

    func touchLeaf(_ touchState: MuTouchState) {
        if touchState.phase == .begin {
            editing = true
            proto?.setAny(named: type.name, CGFloat(1))
        } else if touchState.phase == .ended {
            proto?.setAny(named: type.name, CGFloat(0))
            editing = false
        }
    }
    func updateLeaf(_ any: Any) {
        editing = true
        Schedule(0.125) {
            self.editing = false
        }
    }
}
// View
extension MuLeafTapVm: MuLeafViewProtocol {

    override func valueText() -> String {
        editing ? "1" :  "0"
    }
    override func thumbOffset() -> CGSize {
        CGSize(width: 0, height:  panelVm.runway)
    }
}

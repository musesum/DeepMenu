//  Created by warren on 5/10/22.

import SwiftUI

/// tap control
class MuLeafTapVm: MuLeafVm {

    var value: MuNodeValue?

    init (_ node: MuNode,
          _ branchVm: MuBranchVm,
          _ prevVm: MuNodeVm?,
          icon: String = "") {
        
        super.init(.tap, node, branchVm, prevVm, icon: icon)
        node.leaves.append(self) // MuLeaf delegate for setting value
        value = node.value ?? prevVm?.node.value
    }
}
// Model
extension MuLeafTapVm: MuLeafModelProtocol {

    func touchLeaf(_ point: CGPoint) {

        if point != .zero {
            editing = true
            value?.setAny(named: type.name, CGFloat(1))
        } else {
            value?.setAny(named: type.name, CGFloat(0))
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
        return editing ? "1" :  "0"
    }

    override func thumbOffset() -> CGSize {
        return CGSize(width: 0, height:  panelVm.runway)
    }
}

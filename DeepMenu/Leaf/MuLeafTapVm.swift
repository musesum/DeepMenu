//  Created by warren on 5/10/22.

import SwiftUI

/// tap control
class MuLeafTapVm: MuNodeVm {

    var value: MuNodeValue?
    var status: String { editing ? "1" :  "0" }

    init (_ node: MuNode,
          _ branchVm: MuBranchVm,
          _ prevVm: MuNodeVm?,
          icon: String = "") {
        
        super.init(.tap, node, branchVm, prevVm, icon: icon)
        node.leaves.append(self) // MuLeaf delegate for setting value
        value = node.value ?? prevVm?.node.value
    }

    var offset: CGSize {
        CGSize(width: 0, height:  panelVm.runway)
    }
}

extension MuLeafTapVm: MuLeafProtocol {

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

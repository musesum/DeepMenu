//  Created by warren on 5/10/22.

import SwiftUI

/// tap control
class MuLeafTapVm: MuNodeVm {

    var status: String { editing ? "1" :  "0" }

    init (_ node: MuNode,
          _ branchVm: MuBranchVm,
          _ prevVm: MuNodeVm?,
          icon: String = "") {
        
        super.init(.tap, node, branchVm, prevVm, icon: icon)
        node.leaf = self // MuLeaf delegate for setting value
    }

    var offset: CGSize {
        CGSize(width: 0, height:  panelVm.yRunway())
    }
}
extension MuLeafTapVm: MuLeaf {

    func touchPoint(_ point: CGPoint) {

        if point != .zero {
            editing = true
            node.value?.set(1)
        } else {
            editing = false
            node.value?.set(0)
        }
    }
    func updatePoint(_ point: CGPoint) {
        editing = true
        node.value?.set(1)
        node.value?.set(0)
        editing = false
    }
}

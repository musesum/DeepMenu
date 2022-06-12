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
        node.leaf = self // MuLeaf delegate for setting value
        value = node.value ?? prevVm?.node.value
    }

    var offset: CGSize {
        CGSize(width: 0, height:  panelVm.yRunway())
    }
}

extension MuLeafTapVm: MuLeafProtocol {

    func touchPoint(_ point: CGPoint) {

        if point != .zero {
            editing = true
            value?.set(1)
        } else {
            editing = false
            value?.set(0)
        }
    }
    
    func updatePoint(_ point: CGPoint) {
        editing = true
        value?.set(1)
        value?.set(0)
        editing = false
    }
}

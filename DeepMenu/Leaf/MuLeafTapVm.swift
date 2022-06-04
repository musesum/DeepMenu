//  Created by warren on 5/10/22.

import SwiftUI
import Accelerate
import Tr3

class MuLeafTapVm: MuNodeVm {

    var status: String {
        if editing {
            return "!"
        } else {
            return node.name
        }
    }

    init (_ node: MuNode,
          _ branchVm: MuBranchVm,
          _ parentVm: MuNodeVm?,
          icon: String = "") {
        
        super.init(.tap, node, branchVm, parentVm, icon: icon)
        
        if let node = node as? MuNodeTr3 {
            node.callback(1)
        }
    }

    func touchNow(_ touchNow: CGPoint) {

        if touchNow != .zero {
            editing = true
            node.callback(1)
        } else {
            editing = false
            node.callback(0)
        }
    }

    var offset: CGSize {
        CGSize(width: 0, height:  panelVm.yRunway())
    }
}

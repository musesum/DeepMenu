//  Created by warren on 5/10/22.

import SwiftUI
import Accelerate
import Tr3

class MuLeafTogVm: MuNodeVm {

    var thumb = CGFloat(0)
    var status: String { thumb == 1 ? "1" : "0" }

    init (_ node: MuNode,
          _ branchVm: MuBranchVm,
          _ prevVm: MuNodeVm?,
          icon: String = "") {

        super.init(.tog, node, branchVm, prevVm, icon: icon)
        
        if let node = node as? MuNodeTr3 {
            if let vv = node.tr3.CGFloatVal() {
                thumb = vv
            }
        }
    }

    override func touchNow(_ touchNow: CGPoint) {

        if !editing, touchNow != .zero  {
            editing = true
            thumb = (thumb==1 ? 0 : 1)
            node.callback(thumb)
        } else if editing, touchNow == .zero {
            editing = false
        }
    }

    var offset: CGSize {
        CGSize(width: thumb * panelVm.xRunway(),
               height: 1)
    }
}

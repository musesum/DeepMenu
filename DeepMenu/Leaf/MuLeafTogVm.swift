//  Created by warren on 5/10/22.

import SwiftUI
import Accelerate
import Tr3

class MuLeafTogVm: MuNodeVm {

    var v = CGFloat(0)

    var status: String { get { v == 1 ? "on" : "off" } }

    init (_ node: MuNode,
          _ branchVm: MuBranchVm,
          _ parentVm: MuNodeVm?,
          icon: String = "") {

        super.init(.tog, node, branchVm, parentVm, icon: icon)
        
        if let node = node as? MuNodeTr3 {
            if let vv = node.tr3.CGFloatVal() {
                v = vv
            }
        }
    }

    func touchNow(_ touchNow: CGPoint) {

        if !editing, touchNow != .zero  {
            editing = true
            v = (v==1 ? 0 : 1)
            node.callback(v)
        } else if editing, touchNow == .zero {
            editing = false
        }
    }

    var offset: CGSize {
        get {
            let size = CGSize(width: v * panelVm.xRunway(),
                              height: 0)
            return size
        }
    }
}

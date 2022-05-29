//  Created by warren on 12/10/21.

import SwiftUI
import Accelerate
import Tr3

class MuLeafSegVm: MuNodeVm {

    var v = CGFloat(0)
    
    var status: String {
        get {
            if editing {
                return String(format: "%.1f", v)
            } else {
                return node.name
            }
        }
    }
    
    init (_ node: MuNode,
          _ branchVm: MuBranchVm,
          _ parentVm: MuNodeVm?,
          icon: String = "") {
        
        super.init(.seg, node, branchVm, parentVm, icon: icon)
        
        if let node = node as? MuNodeTr3 ,
           let vv = node.tr3.CGFloatVal() {
            v = vv
        }
    }

    func touchNow(_ touchNow: CGPoint) {

        if touchNow != .zero {
            editing = true
            v = panelVm.normalizeTouch(v: touchNow.y)
            node.callback(v)
        } else {
            editing = false
        }
    }
    
    var offset: CGSize {
        get {
            let size = CGSize(width: 0, height: v * panelVm.yRunway())
            return size
        }
    }
}

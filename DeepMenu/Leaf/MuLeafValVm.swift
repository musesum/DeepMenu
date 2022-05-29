//  Created by warren on 12/10/21.

import SwiftUI
import Accelerate
import Tr3

class MuLeafValVm: MuNodeVm {

    var v = CGFloat(0)
    
    var status: String {
        get {
            if editing {
                return String(format: "%.2f", v)
            } else {
                return node.name
            }
        }
    }
    
    init (_ node: MuNode,
          _ branch: MuBranchVm,
          _ parentVm: MuNodeVm?,
          icon: String = "") {
        
        super.init(.val, node, branch, parentVm, icon: icon)
        
        if let node = node as? MuNodeTr3 ,
           let vv = node.tr3.CGFloatVal() {
            v = vv
        }
    }

    func touchNow(_ touchNow: CGPoint) {

        if touchNow != .zero {
            editing = true
            v = panelVm.normalizeTouch(v: touchNow.y)
            // log("yv", format: "%.2f", [point.y, v])
            node.callback(v)
        } else {
            editing = false
        }
    }
    
    var offset: CGSize {
        get {
            let size = CGSize(width: 0,
                              height: v * panelVm.yRunway())
            return size
        }
    }
}

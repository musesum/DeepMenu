//  Created by warren on 12/10/21.

import SwiftUI
import Accelerate
import Tr3

class MuLeafSegVm: MuNodeVm {

    var thumb = CGFloat(0)
    var status: String { editing ? String(format: "%.1f", thumb) : node.name }
    
    init (_ node: MuNode,
          _ branchVm: MuBranchVm,
          _ prevVm: MuNodeVm?,
          icon: String = "") {
        
        super.init(.seg, node, branchVm, prevVm, icon: icon)
        
        if let node = node as? MuNodeTr3 ,
           let vv = node.tr3.CGFloatVal() {
            thumb = vv
        }
    }

    func touchNow(_ touchNow: CGPoint) {

        if touchNow != .zero {
            editing = true
            thumb = panelVm.normalizeTouch(v: touchNow.y)
            node.callback(thumb)
        } else {
            editing = false
        }
    }
    
    var offset: CGSize { CGSize(width: 0,
                                height: thumb * panelVm.yRunway())
    }
}

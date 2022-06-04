//  Created by warren on 5/10/22.

import SwiftUI
import Accelerate
import Tr3

class MuLeafVxyVm: MuNodeVm {
    
    var thumb: CGPoint = .zero
    
    var status: String {
        if editing {
            return String(format: "x: %.2f, y: %.2f", thumb.x, thumb.y)
        } else {
            return node.name
        }
    }
    
    init (_ node: MuNode,
          _ branchVm: MuBranchVm,
          _ parentVm: MuNodeVm?,
          icon: String = "") {
        
        super.init(.vxy, node, branchVm, parentVm, icon: icon)
        
        if let node = node as? MuNodeTr3,
           let p = node.tr3.CGPointVal() {
            thumb = p
        }
    }
    
    func touchNow(_ touchNow: CGPoint) {
        
        if touchNow != .zero {
            editing = true
            thumb = panelVm.normalizeTouch(xy: touchNow)
            //log("👆", format: "%.2f", [xy])
            node.callback(thumb)
        } else {
            editing = false
        }
    }
    
    var offset: CGSize {
        CGSize(width:  thumb.x * panelVm.xRunway(),
               height: thumb.y * panelVm.yRunway())
    }
}

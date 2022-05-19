//  Created by warren on 12/10/21.

import SwiftUI
import Accelerate
import Tr3

class MuLeafValVm: MuNodeVm {

    var v = CGFloat(0)
    var editing: Bool = false
    
    var status: String {
        get {
            if editing {
                return String(format: "%.1f", v)
            } else {
                return node.name
            }
        }
    }
    
    init (_ branch: MuBranchVm,
          _ node: MuNode,
          _ parentVm: MuNodeVm?,
          icon: String = "") {
        
        super.init(.val, branch, node, parentVm, icon: icon)
        
        if let node = node as? MuNodeTr3 ,
           let vv = node.tr3.CGFloatVal() {
            v = vv
        }
    }

    func touching(_ touching: Bool,
                  _ point: CGPoint) {
        
        //?? let value = border.normalizeTouch(v: point.y)
        if touching {
            v = border.normalizeTouch(v: point.y)
            editing = true
            node.callback(v)
        } else {
            editing = false
        }
    }
    
    var offset: CGSize {
        get {
            let runway = border.thumbRunway
            let size = CGSize(width:  0,
                              height: v * runway)
            return size
        }
    }
}

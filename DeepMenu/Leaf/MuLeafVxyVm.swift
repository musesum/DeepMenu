//  Created by warren on 5/10/22.

import SwiftUI
import Accelerate
import Tr3

class MuLeafVxyVm: MuNodeVm {

    var xy: CGPoint = .zero

    var status: String {
        get {
            if editing {
                return String(format: "x: %.2f, y: %.2f", xy.x, xy.y)
            } else {
                return node.name
            }
        }
    }

    init (_ branch: MuBranchVm,
          _ node: MuNode,
          _ parentVm: MuNodeVm?,
          icon: String = "") {
        
        super.init(.vxy, branch, node, parentVm, icon: icon)
        
        if let node = node as? MuNodeTr3,
           let p = node.tr3.CGPointVal() {
            xy = p
        }
    }

    func touchNow(_ touchNow: CGPoint) {

        if touchNow != .zero {
            editing = true
            xy = panel.normalizeTouch(xy: touchNow)
            //log("👆", format: "%.2f", [xy])
            node.callback(xy)
        } else {
            editing = false
        }
    }

    var offset: CGSize {
        get {
            let size = CGSize(width:  xy.x * panel.xRunway(),
                              height: xy.y * panel.yRunway())
            return size
        }
    }
}

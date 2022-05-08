//  Created by warren on 12/10/21.

import SwiftUI
import Accelerate
import Tr3

class MuLeafVm: MuNodeVm {

    var xy: CGPoint = .zero
    var editing: Bool = false
    
    var status: String {
        get {
            if editing {
                return String(format: "x: %.1f, y: %.1f", xy.x, xy.y)
            } else {
                return node.name
            }
        }
    }
    
    override init (_ type: MuNodeType,
                   _ branch: MuBranchVm,
                   _ node: MuNode,
                   icon: String = "",
                   spotPrev: MuNodeVm?) {
        
        super.init(type, branch, node, icon: icon, spotPrev: spotPrev)
        if let node = node as? MuNodeTr3 {
            let tr3 = node.tr3
            if let p = tr3.CGPointVal() {
                xy = p
            } else if let v = tr3.CGFloatVal() {
                xy = CGPoint(x: v, y: v)
            }
        }
    }

    func touching(_ touching: Bool,_ point: CGPoint) {
        let value = border.normalizeTouch(xy: xy)
        if touching {
            xy = border.normalizeTouch(xy: point)
            // log("◘ ", [xy, leaf.xy, geo.size], format: "%.2f")
            editing = true
            node.callback(value)
        } else {
            editing = false
        }
        
    }
    
    var offset: CGSize {
        get {
            let runway = border.thumbRunway
            let size = CGSize(width:  xy.x * runway,
                              height: xy.y * runway)
            return size
        }
    }
}

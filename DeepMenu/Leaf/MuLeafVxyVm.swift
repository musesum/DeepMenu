//  Created by warren on 5/10/22.

import SwiftUI

/// 2d XY control
class MuLeafVxyVm: MuNodeVm {
    
    var thumb: CGPoint = .zero
    var status: String { editing ? String(format: "x: %.2f, y: %.2f", thumb.x, thumb.y) : node.name }
    
    init (_ node: MuNode,
          _ branchVm: MuBranchVm,
          _ prevVm: MuNodeVm?,
          icon: String = "") {
        
        super.init(.vxy, node, branchVm, prevVm, icon: icon)
        node.leaf = self // MuLeaf delegate for setting value
        thumb = node.value?.get() ?? .zero
    }
    
    var offset: CGSize {
        CGSize(width:  thumb.x * panelVm.xRunway(),
               height: thumb.y * panelVm.yRunway())
    }
}

extension MuLeafVxyVm: MuLeaf {

    func touchPoint(_ point: CGPoint) {

        if point != .zero {
            editing = true
            thumb = panelVm.normalizeTouch(xy: point)
            //log("👆", format: "%.2f", [xy])
            node.value?.set(thumb)
        } else {
            editing = false
        }
    }
    func updatePoint(_ point: CGPoint) {
        editing = true
        thumb = panelVm.normalizeTouch(xy: point)
        editing = false
    }
}

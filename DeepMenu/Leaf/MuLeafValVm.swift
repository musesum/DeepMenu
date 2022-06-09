//  Created by warren on 12/10/21.

import SwiftUI

// 1d slider control
class MuLeafValVm: MuNodeVm {

    var thumb = CGFloat(0)
    var status: String { editing ? String(format: "%.2f", thumb) : node.name }

    init (_ node: MuNode,
          _ branchVm: MuBranchVm,
          _ prevVm: MuNodeVm?,
          icon: String = "") {
        
        super.init(.val, node, branchVm, prevVm, icon: icon)
        node.leaf = self // MuLeaf delegate for setting value
        thumb = node.value?.get() ?? .zero
    }

    var offset: CGSize {
        CGSize(width: 0,
               height: thumb * panelVm.yRunway())
    }
}

extension MuLeafValVm: MuLeaf {

    func touchPoint(_ point: CGPoint) {

        if point != .zero {
            editing = true
            thumb = panelVm.normalizeTouch(v: point.y) //todo: axis ??
            // log("yv", format: "%.2f", [point.y, v])
            node.value?.set(thumb)
        } else {
            editing = false
        }
    }
    func updatePoint(_ point: CGPoint) {
        editing = true
        thumb = panelVm.normalizeTouch(v: point.y) //todo: axis ??
        editing = false
    }
}

//  Created by warren on 12/10/21.

import SwiftUI

/// segmented control
class MuLeafSegVm: MuNodeVm {

    var thumb = CGFloat(0)
    var value: MuNodeValue?
    var status: String { editing ? String(format: "%.1f", thumb) : node.name }
    
    init (_ node: MuNode,
          _ branchVm: MuBranchVm,
          _ prevVm: MuNodeVm?,
          icon: String = "") {
        
        super.init(.seg, node, branchVm, prevVm, icon: icon)
        node.leaf = self // MuLeaf delegate for setting value
        value = node.value ?? prevVm?.node.value
        thumb = value?.get() ?? .zero
    }
    
    var offset: CGSize {
        CGSize(width: 0,
               height: thumb * panelVm.yRunway())
    }
}

extension MuLeafSegVm: MuLeafProtocol {

    func touchPoint(_ point: CGPoint) {

        if point != .zero {
            editing = true
            thumb = panelVm.normalizeTouch(v: point.y) //todo: axis ??
            value?.set(thumb)
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

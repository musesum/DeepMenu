//  Created by warren on 5/10/22.

import SwiftUI

/// 2d XY control
class MuLeafVxyVm: MuNodeVm {
    
    var thumb: CGPoint = .zero
    var value: MuNodeValue?

    var status: String { String(format: "x %.2f y %.2f",
                                thumb.x, thumb.y, id) }
    
    init (_ node: MuNode,
          _ branchVm: MuBranchVm,
          _ prevVm: MuNodeVm?,
          icon: String = "") {
        
        super.init(.vxy, node, branchVm, prevVm, icon: icon)
        node.leaves.append(self)  // MuLeaf delegate for setting value
        value = node.value ?? prevVm?.node.value
        thumb = value?.getPoint() ?? .zero
    }

    var offset: CGSize {
        CGSize(width:  thumb.x * panelVm.runway,
               height: thumb.y * panelVm.runway)
    }
}

extension MuLeafVxyVm: MuLeafProtocol {

    func touchLeaf(_ point: CGPoint) {

        if point != .zero {
            editing = true
            thumb = panelVm.normalizeTouch(xy: point)
            value?.setPoint(thumb)
        } else {
            editing = false
        }
    }
    func updateLeaf(_ any: Any) {
        if let p = any as? CGPoint {
            editing = true
            thumb = p
            editing = false
        }
    }
}

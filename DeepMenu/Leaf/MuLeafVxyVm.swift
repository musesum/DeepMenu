//  Created by warren on 5/10/22.

import SwiftUI

/// 2d XY control
class MuLeafVxyVm: MuLeafVm {
    
    var thumb: CGPoint = .zero
    var value: MuNodeValue?

    init (_ node: MuNode,
          _ branchVm: MuBranchVm,
          _ prevVm: MuNodeVm?,
          icon: String = "") {
        
        super.init(.vxy, node, branchVm, prevVm, icon: icon)
        node.leaves.append(self)  // MuLeaf delegate for setting value
        value = node.value ?? prevVm?.node.value
        thumb = value?.getPoint() ?? .zero
    }
}

extension MuLeafVxyVm: MuLeafModelProtocol {

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

extension MuLeafVxyVm: MuLeafViewProtocol {

    override func status() -> String {
        return String(format: "x %.2f y %.2f", thumb.x, thumb.y, id)
    }

    override func offset() -> CGSize {
        CGSize(width:  thumb.x * panelVm.runway,
               height: thumb.y * panelVm.runway)
    }
}

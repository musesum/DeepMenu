//  Created by warren on 12/10/21.

import SwiftUI

// 1d slider control
class MuLeafValVm: MuNodeVm {

    var thumb = CGFloat(0)
    var value: MuNodeValue?
    var status: String { String(format: "%.2f", thumb) }

    init (_ node: MuNode,
          _ branchVm: MuBranchVm,
          _ prevVm: MuNodeVm?,
          icon: String = "") {
        
        super.init(.val, node, branchVm, prevVm, icon: icon)
        node.leaves.append(self) // MuLeaf delegate for setting value
        value = node.value ?? prevVm?.node.value
        thumb = CGFloat((value?.getAny(named: type.name) as? Float) ?? .zero)
    }

    var offset: CGSize {
        CGSize(width: 0,
               height: thumb * panelVm.yRunway())
    }
}

extension MuLeafValVm: MuLeafProtocol {

    func touchLeaf(_ point: CGPoint) {

        if point != .zero {
            editing = true
            thumb = panelVm.normalizeTouch(v: point.y) //todo: axis ??
            value?.setAny(named: type.name, thumb)
        } else {
            editing = false
        }
    }
    func updateLeaf(_ any: Any) {
        if let v = any as? Float {
            editing = true
            thumb = CGFloat(v)
            editing = false
        }
    }
}

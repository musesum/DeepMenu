//  Created by warren on 5/10/22.

import SwiftUI

/// toggle control
class MuLeafTogVm: MuNodeVm {

    var thumb = CGFloat(0)
    var value: MuNodeValue?
    var status: String { thumb == 1 ? "1" : "0" }

    init (_ node: MuNode,
          _ branchVm: MuBranchVm,
          _ prevVm: MuNodeVm?,
          icon: String = "") {

        super.init(.tog, node, branchVm, prevVm, icon: icon)
        node.leaves.append(self) 
        value = node.value ?? prevVm?.node.value
        thumb = CGFloat(value?.getAny(named: type.name) as? Float ?? .zero)
    }

    var offset: CGSize {
        panelVm.axis == .vertical
        ? CGSize(width: 1, height: thumb * panelVm.runway)
        : CGSize(width: thumb * panelVm.runway, height: 1)
    }
}

extension MuLeafTogVm: MuLeafProtocol {

   func touchLeaf(_ point: CGPoint) {

        if !editing, point != .zero  {
            editing = true
            thumb = (thumb==1 ? 0 : 1)
            value?.setAny(named: type.name, thumb)
        } else if editing, point == .zero {
            editing = false
        }
   }
    func updateLeaf(_ any: Any) {
        if let v = any as? Float {
            editing = true
            thumb = (v < 1 ? 0 : 1)
            editing = false
        }
    }

}

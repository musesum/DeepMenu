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
        thumb = CGFloat(value?.getNamed(type.name) as? Float ?? .zero)
    }


    var offset: CGSize {
        CGSize(width: thumb * panelVm.xRunway(),
               height: 1)
    }
}
extension MuLeafTogVm: MuLeafProtocol {

   func touchLeaf(_ point: CGPoint) {

        if !editing, point != .zero  {
            editing = true
            thumb = (thumb==1 ? 0 : 1)
            value?.setNamed(type.name, thumb)
        } else if editing, point == .zero {
            editing = false
        }
   }
    func updateLeaf(_ any: Any) {
        if let v = any as? CGFloat {
            editing = true
            thumb = (v == .zero ? .zero : 1)
            editing = false
        }
    }

}

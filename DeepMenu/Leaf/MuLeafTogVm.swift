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
        node.leaf = self // MuLeaf delegat
        value = node.value ?? prevVm?.node.value
        thumb = value?.get() ?? .zero
    }


    var offset: CGSize {
        CGSize(width: thumb * panelVm.xRunway(),
               height: 1)
    }
}
extension MuLeafTogVm: MuLeafProtocol {

   func touchPoint(_ point: CGPoint) {

        if !editing, point != .zero  {
            editing = true
            thumb = (thumb==1 ? 0 : 1)
            value?.set(thumb)
        } else if editing, point == .zero {
            editing = false
        }
    }
    func updatePoint(_ point: CGPoint) {
        editing = true
        thumb = (point == .zero ? .zero : 1)
        editing = false
    }

}

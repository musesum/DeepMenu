//  Created by warren on 5/10/22.

import SwiftUI

/// toggle control
class MuLeafTogVm: MuLeafVm {

    var thumb = CGFloat(0)
    var proto: MuNodeProtocol?

    init (_ node: MuNode,
          _ branchVm: MuBranchVm,
          _ prevVm: MuNodeVm?,
          icon: String = "") {

        super.init(.tog, node, branchVm, prevVm, icon: icon)
        node.leaves.append(self) 
        proto = node.proto ?? prevVm?.node.proto
        thumb = CGFloat(proto?.getAny(named: type.name) as? Float ?? .zero)
    }
}
// Model
extension MuLeafTogVm: MuLeafModelProtocol {

    func touchLeaf(_ point: CGPoint) {

        if !editing, point != .zero  {
            editing = true
            thumb = (thumb==1 ? 0 : 1)
            proto?.setAny(named: type.name, thumb)
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
// View
extension MuLeafTogVm: MuLeafViewProtocol {

    override func valueText() -> String {
        thumb == 1 ? "1" : "0"
    }
    override func thumbOffset() -> CGSize {
        panelVm.axis == .vertical
        ? CGSize(width: 1, height: (1-thumb) * panelVm.runway)
        : CGSize(width: thumb * panelVm.runway, height: 1)
    }
}

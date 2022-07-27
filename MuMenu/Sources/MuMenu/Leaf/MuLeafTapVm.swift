//  Created by warren on 5/10/22.

import SwiftUI

/// tap control
public class MuLeafTapVm: MuLeafVm {

    var proto: MuNodeProtocol?
    var thumb = CGFloat.zero

    init (_ node: MuNode,
          _ branchVm: MuBranchVm,
          _ prevVm: MuNodeVm?,
          icon: String = "") {
        
        super.init(.tap, node, branchVm, prevVm, icon: icon)
        node.proxies.append(self) // MuLeaf delegate for setting value
        proto = node.proto ?? prevVm?.node.proto
    }
}
// Model
extension MuLeafTapVm: MuLeafProxy {

    public func touchLeaf(_ touchState: MuTouchState) {
        if touchState.phase == .begin {
            thumb = 1
            updateView()
            editing = true
        } else if touchState.phase == .ended {
            thumb = 0
            updateView()
            editing = false
        }
    }
    public func updateLeaf(_ any: Any) {
        editing = true
        Schedule(0.125) {
            self.editing = false
        }
    }

    // View ----------------

    public func updateView() {
        proto?.setAny(named: nodeType.name, thumb)
    }
    public override func valueText() -> String {
        editing ? "1" :  "0"
    }
    public override func thumbOffset() -> CGSize {
        CGSize(width: 0, height:  panelVm.runway)
    }
}

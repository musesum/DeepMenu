//  Created by warren on 5/10/22.

import SwiftUI

/// toggle control
public class MuLeafTogVm: MuLeafVm {

    var thumb = CGFloat(0)
    var proto: MuNodeProtocol?

    init (_ node: MuNode,
          _ branchVm: MuBranchVm,
          _ prevVm: MuNodeVm?,
          icon: String = "") {

        super.init(.tog, node, branchVm, prevVm, icon: icon)
        node.proxies.append(self) 
        proto = node.proto ?? prevVm?.node.proto
        thumb = CGFloat(proto?.getAny(named: nodeType.name) as? Float ?? .zero)
    }
}
// Model
extension MuLeafTogVm: MuLeafProxy {

    public func touchLeaf(_ touchState: MuTouchState) {
        if !editing, touchState.phase == .begin  {
            thumb = (thumb==1 ? 0 : 1)
            updateView()
            editing = true
        } else if editing,  touchState.phase == .ended {
            editing = false
        }
    }

    public func updateLeaf(_ any: Any) {
        
        if let v = any as? Float {
            editing = true
            thumb = (v < 1 ? 0 : 1)
            editing = false
        }
    }

    // View -----------------------
    
    public func updateView() {
        proto?.setAny(named: nodeType.name, thumb)
    }
    public override func valueText() -> String {
        thumb == 1 ? "1" : "0"
    }
    public override func thumbOffset() -> CGSize {
        panelVm.axis == .vertical
        ? CGSize(width: 1, height: (1-thumb) * panelVm.runway)
        : CGSize(width: thumb * panelVm.runway, height: 1)
    }
}

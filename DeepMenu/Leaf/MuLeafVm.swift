//  Created by warren on 12/10/21.

import SwiftUI
import Accelerate

class MuLeafVm: MuNodeVm {

    var xy: CGPoint = .zero
    var editing: Bool = false
    
    var status: String {
        get {
            if editing {
                return String(format: "x: %.2f, y: %.2f", xy.x, xy.y)
            } else {
                return node.name
            }
        }
    }
    
    override init (_ type: MuNodeType,
          _ branch: MuBranchVm,
          _ node: MuNode,
          icon: String = "",
          spotPrev: MuNodeVm?) {
        
         super.init(type, branch, node, icon: icon, spotPrev: spotPrev)
    }
}

//  Created by warren on 12/10/21.

import SwiftUI
import Accelerate

class MuLeafVm: MuNodeVm {

    var xy: CGPoint = .zero
    var editing: Bool = false
    var status: String { get {
        if editing {
            return String(format: "x: %.2f, y: %.2f", xy.x, xy.y)
        } else {
            return model.name
        }
    }}
    
    init (_ type: MuNodeType,
          _ branch: MuBranchVm,
          _ model: MuNodeModel,
          icon: String = "",
          spotPrev: MuNodeVm?) {
        
         super.init(type, branch, model, icon: icon, spotPrev: spotPrev)
    }
}

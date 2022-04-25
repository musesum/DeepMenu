//  Created by warren on 12/10/21.

import SwiftUI
import Accelerate

class MuLeaf: MuNode {

    var xy: CGPoint = .zero
    var editing: Bool = false
    var status: String { get {
        if editing {
            return String(format: "x: %.2f, y: %.2f", xy.x, xy.y)
        } else {
            return model.title
        }
    }}
    
    init (_ type: MuBorderType,
          _ branch: MuBranch,
          _ model: MuNodeModel,
          icon: String = "",
          suprNode: MuNode?) {
        
         super.init(type, branch, model, icon: icon, suprNode: suprNode)
    }
}

//  Created by warren on 12/10/21.

import SwiftUI
import Accelerate

class MuLeaf: MuPod {

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
          _ dock: MuDock,
          _ model: MuPodModel,
          icon: String = "",
          suprPod: MuPod?) {
        
         super.init(type, dock, model, icon: icon, suprPod: suprPod)
    }
}

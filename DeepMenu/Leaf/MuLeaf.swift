//  Created by warren on 12/10/21.

import SwiftUI
import Accelerate

class MuLeaf: MuPod {

    var thumb: CGPoint = .zero
    
    init (_ type: MuBorderType,
          _ dock: MuDock,
          _ model: MuPodModel,
          icon: String = "",
          suprPod: MuPod?) {
        
        super.init(type, dock, model, icon: icon, suprPod: suprPod)
    }
}

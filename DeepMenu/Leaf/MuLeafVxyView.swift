//  Created by warren on 5/10/22.

import SwiftUI

struct MuLeafVxyView: View {
    
    @ObservedObject var leafVm: MuLeafVxyVm
    var panelVm: MuPanelVm { leafVm.panelVm }
    
    var body: some View {
        VStack {
            MuLeafTitleView(leafVm)
            MuLeafBodyView(leafVm) {
                Capsule()
                    .fill(.white)
                    .frame(width: panelVm.thumbDiameter,
                           height: panelVm.thumbDiameter)
                    .offset(leafVm.offset())
                    .allowsHitTesting(false)
            }
        }
    }
}

//  Created by warren on 5/10/22.

import SwiftUI

struct MuLeafVxyView: View {
    
    @ObservedObject var leafVm: MuLeafVxyVm
    var panelVm: MuPanelVm { leafVm.panelVm }
    
    var body: some View {
        VStack {
            MuLeafTitleView(leafVm)
            MuLeafBodyView(leafVm) {
                ZStack {
                    // tick marks
                    ForEach(leafVm.ticks, id: \.self) {
                        Capsule()
                            .fill(.gray)
                            .frame(width: 4, height: 4)
                            .offset(CGSize(width: $0.width, height: $0.height))
                            .allowsHitTesting(false)
                    }
                    // thumb dot
                    Capsule()
                        .fill(.white)
                        .frame(width: panelVm.thumbDiameter,
                               height: panelVm.thumbDiameter)
                        .offset(leafVm.thumbOffset())
                        .allowsHitTesting(false)
                }
            }
        }
    }
}

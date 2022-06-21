// Created by warren on 10/17/21.

import SwiftUI

struct MuLeafSegView: View {
    
    @ObservedObject var leafVm: MuLeafSegVm
    var panelVm: MuPanelVm { leafVm.panelVm }

    var body: some View {
        MuLeafView(leafVm) {
            ForEach(leafVm.ticks, id: \.self) {
                Capsule()
                    .fill(.gray)
                    .frame(width: 4, height: 4)
                    .offset(CGSize(width: $0.width, height: $0.height))
                    .allowsHitTesting(false)
            }
            Capsule()
                .fill(.white)
                .frame(width:  panelVm.thumbDiameter,
                       height: panelVm.thumbDiameter)
                .offset(leafVm.offset())
                .allowsHitTesting(false)
        }
    }
}


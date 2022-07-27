// Created by warren on 10/17/21.

import SwiftUI

struct MuLeafValView: View {

    @ObservedObject var leafVm: MuLeafVm
    var panelVm: MuPanelVm { leafVm.panelVm }

    var body: some View {
        MuLeafView(leafVm) {
            Capsule()
                .fill(.white)
                .frame(width:  panelVm.thumbDiameter,
                       height: panelVm.thumbDiameter)
                .offset(leafVm.thumbOffset())
                .allowsHitTesting(false)
        }
    }
}

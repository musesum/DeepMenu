//  Created by warren on 5/10/22.

import SwiftUI

/// Toggle 0/1 (off/on)
struct MuLeafTogView: View {
    
    @ObservedObject var leafVm: MuLeafTogVm
    var panelVm: MuPanelVm { leafVm.panelVm }
    var thumbFill: Color   { Layout.thumbColor(leafVm.thumb) }

    var body: some View {
        MuLeafView(leafVm) {
            Capsule()
                .fill(thumbFill)
                .frame(width: panelVm.thumbDiameter,
                       height: panelVm.thumbDiameter)
                .offset(leafVm.thumbOffset())
                .allowsHitTesting(false)
        }
    }
}

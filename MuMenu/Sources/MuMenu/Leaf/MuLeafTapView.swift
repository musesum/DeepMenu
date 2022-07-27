//  Created by warren on 5/10/22.

import SwiftUI

struct MuLeafTapView: View {

    @ObservedObject var leafVm: MuLeafTapVm
    var panelVm: MuPanelVm { leafVm.panelVm }
    var fillColor: Color { Layout.tapColor(leafVm.editing) }

    var body: some View {
        MuLeafView(leafVm) {
            RoundedRectangle(cornerRadius: panelVm.cornerRadius)
                .fill(fillColor)
                .frame(width:  panelVm.inner.width,
                       height: panelVm.inner.height)
                .animation(Layout.flashAnim, value: fillColor)
                .allowsHitTesting(false)
        }
    }
}

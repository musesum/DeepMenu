//  Created by warren on 5/23/22.

import SwiftUI

struct MuPanelView: View {

    @GestureState private var touchXY: CGPoint = .zero

    var leafVm: MuLeafVm
    var panelVm: MuPanelVm { leafVm.panelVm }
    var strokeColor: Color   { Layout.strokeColor(leafVm.spotlight) }
    var strokeWidth: CGFloat { Layout.strokeWidth(leafVm.spotlight) }
    
    var body: some View {
        ZStack {
            // fill
            RoundedRectangle(cornerRadius: panelVm.cornerRadius)
                .fill(Layout.panelFill)
                .overlay(RoundedRectangle(cornerRadius: panelVm.cornerRadius)
                    .stroke(strokeColor, lineWidth: strokeWidth))
                .frame(width:  panelVm.inner.width,
                       height: panelVm.inner.height)
        }
    }
}

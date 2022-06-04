//  Created by warren on 5/23/22.

import SwiftUI

struct MuPanelView: View {
    @GestureState private var touchXY: CGPoint = .zero
    var panelVm: MuPanelVm
    var editing: Bool
    var strokeColor: Color   { Layout.strokeColor(editing) }
    var strokeWidth: CGFloat { Layout.strokeWidth(editing) }

    var body: some View {
        ZStack {
            GeometryReader { geo in
                RoundedRectangle(cornerRadius: panelVm.cornerRadius)
                    .fill(Layout.panelFill)
                    .frame(width: panelVm.inner.width, height: panelVm.inner.height)

                RoundedRectangle(cornerRadius: panelVm.cornerRadius)
                    .stroke(strokeColor, lineWidth: strokeWidth)
                    .frame(width: panelVm.inner.width, height: panelVm.inner.height)
                    .animation(Layout.flashAnim, value: strokeColor)
                    .animation(Layout.flashAnim, value: strokeWidth)
            }
        }
    }
}

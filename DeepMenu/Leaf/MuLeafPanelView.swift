//  Created by warren on 5/23/22.

import SwiftUI

struct MuLeafPanelView: View {
    @GestureState private var touchXY: CGPoint = .zero
    var panel: MuPanel
    var editing: Bool
    var strokeColor: Color   { get { Layout.strokeColor(editing) }}
    var strokeWidth: CGFloat { get { Layout.strokeWidth(editing) }}

    var body: some View {
        ZStack {
            GeometryReader { geo in
                RoundedRectangle(cornerRadius: panel.cornerRadius)
                    .fill(Layout.panelFill)
                    .frame(width: panel.inner.width, height: panel.inner.height)

                RoundedRectangle(cornerRadius: panel.cornerRadius)
                    .stroke(strokeColor, lineWidth: strokeWidth)
                    .frame(width: panel.inner.width, height: panel.inner.height)
                    .animation(Layout.flash(), value: strokeColor)
                    .animation(Layout.flash(), value: strokeWidth)
            }
        }
    }
}

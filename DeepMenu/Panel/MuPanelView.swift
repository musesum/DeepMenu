//  Created by warren on 5/23/22.

import SwiftUI

struct MuPanelView: View {

    @GestureState private var touchXY: CGPoint = .zero

    var panelVm: MuPanelVm
    var nodeVm: MuNodeVm
    var strokeColor: Color   { Layout.strokeColor(nodeVm.editing) }
    var strokeWidth: CGFloat { Layout.strokeWidth(nodeVm.editing) }

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
            .gesture(DragGesture(minimumDistance: 0)
                .updating($touchXY) { (input, result, _) in
                    result = input.location })
            .onChange(of: touchXY) { nodeVm.touchNow($0) }

        }
    }
}

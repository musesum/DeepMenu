//  Created by warren on 5/23/22.

import SwiftUI

struct MuPanelView: View {

    @GestureState private var touchXY: CGPoint = .zero

    var leafVm: MuLeafVm
    var panelVm: MuPanelVm { leafVm.panelVm }
    var rootVm: MuRootVm { leafVm.branchVm.treeVm.rootVm! }
    var strokeColor: Color   { Layout.strokeColor(leafVm.editing) }
    var strokeWidth: CGFloat { Layout.strokeWidth(leafVm.editing) }
    
    var body: some View {
        ZStack {
            // fill
            RoundedRectangle(cornerRadius: panelVm.cornerRadius)
                .fill(Layout.panelFill)
                .frame(width:  panelVm.inner.width,
                       height: panelVm.inner.height)
            // stroke
            RoundedRectangle(cornerRadius: panelVm.cornerRadius)
                .stroke(strokeColor, lineWidth: strokeWidth)
                .frame(width:  panelVm.inner.width,
                       height: panelVm.inner.height)
                .animation(Layout.flashAnim, value: strokeColor)
                .animation(Layout.flashAnim, value: strokeWidth)
        }
        .coordinateSpace(name: "Space")
        .gesture(DragGesture(minimumDistance: 0)
            .updating($touchXY) { (input, result, _) in result = input.location })
        .onChange(of: touchXY) {
            for leaf in leafVm.node.leaves {
                //?? rootVm.touchVm.touchUpdate($0)
                leaf.touchLeaf($0)
            }
        }
    }
}

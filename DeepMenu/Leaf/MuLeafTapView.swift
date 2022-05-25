//  Created by warren on 5/10/22.

import SwiftUI

struct MuLeafTapView: View {

    @ObservedObject var leafVm: MuLeafTapVm
    @GestureState private var touchXY: CGPoint = .zero
    var panel: MuPanel { get { leafVm.panel } }
    var fillColor  : Color   { get { Layout.fillColor(leafVm.editing) }}
    var strokeColor: Color   { get { Layout.strokeColor(leafVm.editing) }}
    var strokeWidth: CGFloat { get { Layout.strokeWidth(leafVm.editing) }}
    
    var body: some View {
        VStack {
            Text(leafVm.status)
                .scaledToFit()
                .foregroundColor(Color.white)
            ZStack {
                GeometryReader { geo in
                    RoundedRectangle(cornerRadius: leafVm.panel.cornerRadius)
                        .fill(Layout.panelFill)
                        .frame(width: panel.inner.width, height: panel.inner.height)
                        .animation(Layout.flash(), value: fillColor)
                    RoundedRectangle(cornerRadius: panel.cornerRadius)
                        .stroke(strokeColor, lineWidth: strokeWidth)
                        .frame(width: panel.inner.width, height: panel.inner.height)
                        .animation(Layout.flash(), value: strokeColor)
                        .animation(Layout.flash(), value: strokeWidth)
                }
                .gesture(DragGesture(minimumDistance: 0)
                    .updating($touchXY) { (input, result, _) in
                        result = input.location })
                .onChange(of: touchXY) { leafVm.touchNow($0) }
            }
        }
    }
}

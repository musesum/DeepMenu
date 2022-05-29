//  Created by warren on 5/10/22.

import SwiftUI

struct MuLeafTapView: View {

    @ObservedObject var leafVm: MuLeafTapVm
    @GestureState private var touchXY: CGPoint = .zero
    var panelVm     : MuPanelVm { get { leafVm.panelVm } }
    var fillColor   : Color     { get { Layout.fillColor(leafVm.editing) }}
    var strokeColor : Color     { get { Layout.strokeColor(leafVm.editing) }}
    var strokeWidth : CGFloat   { get { Layout.strokeWidth(leafVm.editing) }}

    var body: some View {
        VStack {
            Text(leafVm.status)
                .scaledToFit()
                .foregroundColor(Color.white)
            ZStack {
                GeometryReader { geo in
                    RoundedRectangle(cornerRadius: leafVm.panelVm.cornerRadius)
                        .fill(Layout.panelFill)
                        .frame(width: panelVm.inner.width, height: panelVm.inner.height)
                        .animation(Layout.flash(), value: fillColor)
                    RoundedRectangle(cornerRadius: panelVm.cornerRadius)
                        .stroke(strokeColor, lineWidth: strokeWidth)
                        .frame(width: panelVm.inner.width, height: panelVm.inner.height)
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

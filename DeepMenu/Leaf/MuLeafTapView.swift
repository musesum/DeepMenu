//  Created by warren on 5/10/22.

import SwiftUI

struct MuLeafTapView: View {

    @ObservedObject var leafVm: MuLeafTapVm
    @GestureState private var touchXY: CGPoint = .zero
    var panelVm: MuPanelVm { leafVm.panelVm }
    var fillColor: Color { Layout.fillColor(leafVm.editing) }
    var strokeColor: Color { Layout.strokeColor(leafVm.editing) }
    var strokeWidth: CGFloat { Layout.strokeWidth(leafVm.editing) }
    
    var body: some View {
        VStack {
            Text(leafVm.status)
                .scaledToFit()
                .foregroundColor(Color.white)
            ZStack {
                GeometryReader { geo in
                    MuPanelView(panelVm: panelVm, nodeVm: leafVm)
                }
            }
        }
    }
}

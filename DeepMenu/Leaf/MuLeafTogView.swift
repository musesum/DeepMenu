//  Created by warren on 5/10/22.

import SwiftUI

struct MuLeafTogView: View {
    
    @ObservedObject var leafVm: MuLeafTogVm
    @GestureState private var touchXY: CGPoint = .zero
    var panelVm: MuPanelVm { leafVm.panelVm }
    var thumbFill: Color   { Layout.thumbColor(leafVm.thumb) }
    
    var body: some View {
        VStack {
            Text(leafVm.status)
                .scaledToFit()
                .minimumScaleFactor(0.01)
                .foregroundColor(Color.white)
            ZStack {
                GeometryReader { geo in
                    MuPanelView(panelVm: panelVm, nodeVm: leafVm)
                    Capsule()
                        .fill(thumbFill)
                        .frame(width: panelVm.thumbRadius*2,
                               height: panelVm.thumbRadius*2)
                        .offset(leafVm.offset)
                        .allowsHitTesting(false)
                }
            }
        }
    }
}

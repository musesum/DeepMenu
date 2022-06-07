// Created by warren on 10/17/21.

import SwiftUI

struct MuLeafSegView: View {
    
    @ObservedObject var leafVm: MuLeafSegVm
    @GestureState private var touchXY: CGPoint = .zero
    var panelVm: MuPanelVm { leafVm.panelVm }
    
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
                        .fill(.white)
                        .frame(width: panelVm.inner.width, height: panelVm.thumbRadius*2)
                        .offset(leafVm.offset)
                        .allowsHitTesting(false)
                }
            }
        }
    }
}

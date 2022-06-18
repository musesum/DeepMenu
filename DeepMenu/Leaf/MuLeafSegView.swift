// Created by warren on 10/17/21.

import SwiftUI

struct MuLeafSegView: View {
    
    @ObservedObject var leafVm: MuLeafSegVm
    @GestureState private var touchXY: CGPoint = .zero
    var panelVm: MuPanelVm { leafVm.panelVm }
    var ticks: [CGFloat] { leafVm.ticks }
    
    var body: some View {
        VStack {
            Text(leafVm.status)
                .scaledToFit()
                .minimumScaleFactor(0.01)
                .foregroundColor(Color.white)
            ZStack {
                GeometryReader { geo in
                    MuPanelView(panelVm: panelVm, nodeVm: leafVm)
                    ForEach(ticks, id: \.self) {
                        Capsule()
                            .fill(.gray)
                            .frame(width: 4, height: 4)
                            .offset(CGSize(width: panelVm.inner.width/2-2,
                                           height: $0-1))
                            .allowsHitTesting(false)
                    }
                    Capsule()
                        .fill(.white)
                        .frame(width: panelVm.inner.width,
                               height: panelVm.thumbRadius*2)
                        .offset(leafVm.offset)
                        .allowsHitTesting(false)
                }
            }
        }
    }
}

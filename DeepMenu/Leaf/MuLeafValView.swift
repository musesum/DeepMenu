// Created by warren on 10/17/21.

import SwiftUI

struct MuLeafValView: View {

    @ObservedObject var leafVm: MuLeafValVm
    @GestureState private var touchXY: CGPoint = .zero
    var panelVm: MuPanelVm { get { leafVm.panelVm } }

    var body: some View {
        VStack {
            Text(leafVm.status)
                .scaledToFit()
                .minimumScaleFactor(0.01)
                .foregroundColor(Color.white)
            ZStack {
                GeometryReader { geo in
                    MuPanelView(panelVm: panelVm, editing: leafVm.editing)
                        .gesture(DragGesture(minimumDistance: 0)
                            .updating($touchXY) { (input, result, _) in
                                result = input.location })
                        .onChange(of: touchXY) { leafVm.touchNow($0) }
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

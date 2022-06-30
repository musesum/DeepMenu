// Created by warren 10/29/21.

import SwiftUI

struct MuTouchView: View {

    @ObservedObject var touchVm: MuTouchVm

    var body: some View {

        GeometryReader() { geo in
            // root icon
            if let rootNodeVm = touchVm.rootNodeVm {
                
                MuNodeView(nodeVm: rootNodeVm)
                    .frame(width: Layout.diameter, height: Layout.diameter)
                    .onAppear { touchVm.updateRootIcon(geo.frame(in: .named("Canvas"))) }
                    .onChange(of: geo.frame(in: .named("Canvas"))) { touchVm.updateRootIcon($0) }
                    .padding(Layout.padding)
                    .opacity(touchVm.rootAlpha + 0.1)
                    .position(touchVm.rootIconXY)
            }

            // hovering node icon, follows touch
            if let dragNodeVm = touchVm.dragNodeVm {

                MuNodeView(nodeVm: dragNodeVm)
                    .position(touchVm.dragIconXY)
                    .animation(.easeInOut(duration: Layout.animate), value: touchVm.dragIconXY)
                
                    .opacity(1-touchVm.rootAlpha)
                    .offset(touchVm.dragNodeΔ)
            }
        }
        .animation(.easeInOut(duration: Layout.animate), value: touchVm.rootAlpha)
    }
}

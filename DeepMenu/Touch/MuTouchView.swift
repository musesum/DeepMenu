// Created by warren 10/29/21.

import SwiftUI

struct MuTouchView: View {

    @ObservedObject var touchVm: MuTouchVm

    var body: some View {

        GeometryReader() { geo in
            // home (root) icon
            if let homeNodeVm = touchVm.homeNodeVm {
                MuNodeView(nodeVm: homeNodeVm)

                    .frame(width: Layout.diameter, height: Layout.diameter)
                    .onAppear { touchVm.updateHome(geo.frame(in: .named("Space"))) }
                    .onChange(of: geo.frame(in: .named("Space"))) { touchVm.updateHome($0) }
                    .padding(Layout.padding)
                    .opacity(touchVm.alpha + 0.1)
                    .position(touchVm.pointHome)
            }

            // hovering node icon, follows touch
            if let dragNodeVm = touchVm.dragNodeVm {

                MuNodeView(nodeVm: dragNodeVm)
                    .position(touchVm.pointNow)
                    .animation(.easeInOut(duration: Layout.animate), value: touchVm.pointNow)
                    .opacity(1-touchVm.alpha)
                    .offset(touchVm.pilotOfs)
            }
        }
        .animation(.easeInOut(duration: Layout.animate), value: touchVm.alpha)
    }
}

// Created by warren on 9/30/21.

import SwiftUI

struct MuBranchView: View, Identifiable {
    var id = MuIdentity.getId()

    @EnvironmentObject var rootVm: MuRootVm
    @ObservedObject var branch: MuBranchVm

    var opacity: CGFloat { branch.show ? 1 : 0 }
    var panelVm: MuPanelVm { branch.panelVm }
    @GestureState private var touchXY: CGPoint = .zero

    var body: some View {
        GeometryReader { geo in
            ZStack {
                MuBranchPanelView(panelVm: panelVm)

                let reverse = (panelVm.axis == .vertical
                               ? rootVm.corner.contains(.lower) ? true : false
                               : rootVm.corner.contains(.left)  ? true : false )

                MuPanelAxisView(panelVm) {
                    ForEach(reverse
                            ? branch.nodeVms.reversed()
                            : branch.nodeVms, id: \.id) {
                        MuNodeView(nodeVm: $0)
                    }
                }
            }
            .onAppear { branch.updateBounds(geo.frame(in: .named("Space"))) }
            .onChange(of: geo.frame(in: .named("Space"))) { branch.updateBounds($0) }
        }
        .frame(width: panelVm.outer.width,
               height: panelVm.outer.height)
        .opacity(opacity)
        .animation(.easeInOut(duration: Layout.animate/2), value: opacity)
        //.onTapGesture { } // allow scrolling
    }
}

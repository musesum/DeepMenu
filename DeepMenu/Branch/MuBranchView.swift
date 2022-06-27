// Created by warren on 9/30/21.

import SwiftUI

struct MuBranchView: View {
    //var id = MuIdentity.getId()

    @EnvironmentObject var rootVm: MuRootVm
    @ObservedObject var branchVm: MuBranchVm

    var opacity: CGFloat { branchVm.show ? 1 : 0 }
    var panelVm: MuPanelVm { branchVm.panelVm }
    var spotlight: Bool

    var body: some View {
        GeometryReader { geo in
            ZStack {
                MuBranchPanelView(panelVm: panelVm,
                                  spotlight: spotlight)

                let reverse = (panelVm.axis == .vertical
                               ? rootVm.corner.contains(.lower) ? true : false
                               : rootVm.corner.contains(.right) ? true : false )

                MuPanelAxisView(panelVm) {
                    ForEach(reverse
                            ? branchVm.nodeVms.reversed()
                            : branchVm.nodeVms) {
                        MuNodeView(nodeVm: $0)
                    }
                }
            }
            .onAppear { branchVm.updateBounds(geo.frame(in: .named("Space"))) }
            .onChange(of: geo.frame(in: .named("Space"))) { branchVm.updateBounds($0) }
        }
        .frame(width: panelVm.outer.width, height: panelVm.outer.height)
        .opacity(opacity)
        .animation(.easeInOut(duration: Layout.animate/2), value: opacity)
        //.onTapGesture { } // allow scrolling
    }
}

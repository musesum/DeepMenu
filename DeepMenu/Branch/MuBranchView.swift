// Created by warren on 9/30/21.

import SwiftUI

struct MuBranchView: View, Identifiable {
    var id = MuIdentity.getId()

    @EnvironmentObject var root: MuRootVm
    @ObservedObject var branch: MuBranchVm

    var opacity: CGFloat { get { branch.show ? 1 : 0 }}
    var panelVm: MuPanelVm { get { branch.panelVm } }
    @GestureState private var touchXY: CGPoint = .zero

    var body: some View {
        GeometryReader { geo in
            ZStack {
                MuBranchPanelView(panelVm: panelVm)

                let reverse = (panelVm.axis == .vertical
                               ? root.corner.contains(.lower) ? true : false
                               : root.corner.contains(.left)  ? true : false )

                MuPanelAxisView(panelVm) {
                    ForEach(reverse
                            ? branch.nodeVms.reversed()
                            : branch.nodeVms, id: \.id) {
                        MuNodeView(nodeVm: $0)
                    }
                }
            }
            .onAppear { branch.updateBounds(geo.frame(in: .named("Sky"))) }
            .onChange(of: geo.frame(in: .named("Sky"))) { branch.updateBounds($0) }
        }
        .frame(width: panelVm.outer.width, height: panelVm.outer.height)

        .opacity(opacity)
        .animation(.easeInOut(duration: Layout.animate/2), value: opacity)
        //.onTapGesture { } // allow scrolling
        .offset(branch.branchShift)
        .animation(.easeIn(duration: Layout.animate), value: branch.branchShift)
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .named("Sky"))
                .updating($touchXY) { (value, touchXY, _) in touchXY = value.location })
        .onChange(of: touchXY) { root.touchVm.touchUpdate($0, branch) }
    }
}

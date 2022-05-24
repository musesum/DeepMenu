// Created by warren on 9/30/21.

import SwiftUI

struct MuBranchView: View, Identifiable {
    var id = MuIdentity.getId()

    @EnvironmentObject var root: MuRootVm
    @ObservedObject var branch: MuBranchVm

    var opacity: CGFloat { get { branch.show ? 1 : 0.0 }}
    var panel: MuPanel { get { branch.panel } }
    @GestureState private var touchXY: CGPoint = .zero

    var body: some View {
        GeometryReader { geo in
            ZStack {
                MuBranchRectView(panel: panel)

                let reverse = (panel.axis == .vertical
                               ? root.corner.contains(.lower) ? true : false
                               : root.corner.contains(.left)  ? true : false )

                HVScroll(panel) {
                    ForEach(reverse ? branch.branchNodes.reversed() : branch.branchNodes, id: \.id) {
                        MuNodeView(node: $0)
                    }
                }
            }
            .onAppear { branch.updateBounds(geo.frame(in: .named("Space"))) }
            .onChange(of: geo.frame(in: .named("Space"))) { branch.updateBounds($0) }
        }
        .frame(width: panel.outer.width, height: panel.outer.height)

        .opacity(opacity)
        .animation(.easeInOut(duration: Layout.animate/2), value: opacity)
        //.onTapGesture { } // allow scrolling
        .offset(branch.branchShift)
        .animation(.easeIn(duration: Layout.animate), value: branch.branchShift)
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .named("Space"))
                .updating($touchXY) { (value, touchXY, _) in touchXY = value.location })
        .onChange(of: touchXY) { root.pilotVm.touchUpdate($0, branch) }
    }
}

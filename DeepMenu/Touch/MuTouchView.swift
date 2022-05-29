// Created by warren 10/29/21.

import SwiftUI

struct MuTouchView: View {

    @ObservedObject var touchVm: MuTouchVm
    @GestureState private var touchXY: CGPoint = .zero

    var body: some View {
        Group {
            // root icon
            GeometryReader() { geo in
                if let homeNodeVm = touchVm.homeNodeVm {
                    MuNodeView(nodeVm: homeNodeVm)

                        .frame(width: Layout.diameter, height: Layout.diameter)
                        .onAppear { touchVm.updateHome(geo.frame(in: .named("Space"))) }
                        .onChange(of: geo.frame(in: .named("Space"))) { touchVm.updateHome($0) }
                        .padding(Layout.spacing)
                        .opacity(touchVm.alpha + 0.1)
                        .position(touchVm.pointHome)

                        .gesture(
                            DragGesture(minimumDistance: 0, coordinateSpace: .named("Space"))
                                .updating($touchXY) { (value, touchXY, _) in touchXY = value.location })
                        .onChange(of: touchXY) { touchVm.touchUpdate($0, nil) }
                }
            }

            // hovering node icon, follows touch
            GeometryReader { geo in
                if let dragNodeVm = touchVm.dragNodeVm {
                   
                    MuNodeView(nodeVm: dragNodeVm)
                        .position(touchVm.pointNow)
                        .animation(.easeInOut(duration: Layout.animate), value: touchVm.pointNow)
                        .opacity(1-touchVm.alpha)
                        .offset(touchVm.pilotOfs)
                }
            }
        }
        .animation(.easeInOut(duration: Layout.animate), value: touchVm.alpha)
    }
}

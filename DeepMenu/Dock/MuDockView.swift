// Created by warren on 9/30/21.

import SwiftUI

struct MuDockView: View, Identifiable {
    var id = MuIdentity.getId()

    @EnvironmentObject var hub: MuHub
    @ObservedObject var dock: MuDock

    var opacity: CGFloat { get { dock.show ? 1 : 0.0 }}
    var border: MuBorder { get { dock.border } }
    @GestureState private var touchXY: CGPoint = .zero

    var body: some View {
        GeometryReader { geo in
            ZStack {
                MuDockRectView(border: border)

                let reverse = (border.vert
                               ? hub.corner.contains(.lower) ? true : false
                               : hub.corner.contains(.left)  ? true : false )

                HVScroll(border) {
                    ForEach(reverse ? dock.subPods.reversed() : dock.subPods, id: \.id) {
                        MuPodView(pod: $0)
                    }
                }
            }
            .onAppear { dock.updateBounds(geo.frame(in: .named("Space"))) }
            .onChange(of: geo.frame(in: .named("Space"))) { dock.updateBounds($0) }
        }
        .frame(width:  border.width, height: border.height)

        .opacity(opacity)
        .animation(.easeInOut(duration: Layout.animate/2), value: opacity)
        //.onTapGesture { } // allow scrolling
        .offset(dock.dockShift)
        .animation(.easeIn(duration: Layout.animate), value: dock.dockShift)
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .named("Space"))
                .updating($touchXY) { (value, touchXY, _) in touchXY = value.location })
        .onChange(of: touchXY) { hub.pilot.touchUpdate($0, dock) }
    }
}

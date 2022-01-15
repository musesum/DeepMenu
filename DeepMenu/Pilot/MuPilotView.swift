// Created by warren 10/29/21.

import SwiftUI

struct MuPilotView: View {

    @ObservedObject var pilot: MuPilot
    @GestureState private var touchXY: CGPoint = .zero

    var body: some View {
        Group {
            // hub icon
            GeometryReader() { geo in
                MuPodView(pod: pilot.hubPod)

                    .frame(width: Layout.diameter, height: Layout.diameter)
                    .onAppear { pilot.updateHome(geo.frame(in: .named("Space"))) }
                    .onChange(of: geo.frame(in: .named("Space"))) { pilot.updateHome($0) }

                    .padding(Layout.spacing)
                    .opacity(pilot.alpha + 0.1)
                    .position(pilot.homeHubXY)

                    .gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .named("Space"))
                            .updating($touchXY) { (value, touchXY, _) in touchXY = value.location })
                    .onChange(of: touchXY) { pilot.touchUpdate($0, nil) }
            }

            // fly icon
            GeometryReader { geo in
                if let flyPod = pilot.flyPod {
                    MuPodView(pod: flyPod)
                        .position(pilot.pointNow)
                        .animation(.easeInOut(duration: Layout.animate), value: pilot.pointNow)
                        .opacity(1-pilot.alpha)
                        .offset(pilot.pilotOfs)
                }
            }
        }
        .animation(.easeInOut(duration: Layout.animate), value: pilot.alpha)
    }
}

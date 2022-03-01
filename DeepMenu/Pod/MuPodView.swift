// Created by warren on 10/1/21.

import SwiftUI

struct MuPodView: View {

    @ObservedObject var pod: MuPod
    var border: MuBorder { get { pod.border } }

    var body: some View {
        GeometryReader() { geo in
            let isThumbInput = pod.border.type == .rect
            Group {
                if isThumbInput {
                    MuPodXYRectView(pod: pod)
                } else {
                    if pod.icon.isEmpty { MuPodTitleView(pod: pod) }
                    else { Image(pod.icon).resizable() }
                }
            }
            .onChange(of: geo.frame(in: .named("Space"))) { pod.updateCenter($0) }
            .onAppear { pod.updateCenter(geo.frame(in: .named("Space"))) }
        }
        .frame(width: border.diameter, height: border.diameter)
        .padding(border.spacing)
        .allowsHitTesting(true)
        .animation(.easeInOut(duration: Layout.animate), value: pod.podXY)
    }
}



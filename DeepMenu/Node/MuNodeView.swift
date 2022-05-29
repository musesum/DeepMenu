// Created by warren on 10/1/21.

import SwiftUI

struct MuNodeView: View {

    @ObservedObject var nodeVm: MuNodeVm
    var panelVm: MuPanelVm { get { nodeVm.panelVm } }

    var body: some View {
        GeometryReader() { geo in
            Group {
                switch nodeVm {
                    case let n as MuLeafVxyVm: MuLeafVxyView(leafVm: n)
                    case let n as MuLeafValVm: MuLeafValView(leafVm: n)
                    case let n as MuLeafSegVm: MuLeafSegView(leafVm: n)
                    case let n as MuLeafTogVm: MuLeafTogView(leafVm: n)
                    case let n as MuLeafTapVm: MuLeafTapView(leafVm: n)

                    default:
                        if nodeVm.icon.isEmpty {
                            MuNodeTextView(node: nodeVm)
                        } else {
                            Image(nodeVm.icon).resizable()
                        }
                }
            }
            .onChange(of: geo.frame(in: .named("Sky"))) {
                nodeVm.updateCenter($0)
            }
            .onAppear { nodeVm.updateCenter(geo.frame(in: .named("Sky"))) }
        }
        .frame(width: panelVm.inner.width, height: panelVm.inner.height)
        .padding(Layout.spacing)
        .allowsHitTesting(true)
        .animation(.easeInOut(duration: Layout.animate), value: nodeVm.center)
    }
}



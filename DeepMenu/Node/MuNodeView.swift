// Created by warren on 10/1/21.

import SwiftUI

struct MuNodeView: View {

    @ObservedObject var node: MuNodeVm
    var panel: MuPanel { get { node.panel } }

    var body: some View {
        GeometryReader() { geo in
            Group {
                switch node {

                    case let leaf as MuLeafVxyVm: MuLeafVxyView(leafVm: leaf)
                    case let leaf as MuLeafValVm: MuLeafValView(leafVm: leaf)
                    case let leaf as MuLeafSegVm: MuLeafSegView(leafVm: leaf)
                    case let leaf as MuLeafTogVm: MuLeafTogView(leafVm: leaf)
                    case let leaf as MuLeafTapVm: MuLeafTapView(leafVm: leaf)

                    default:

                        if node.icon.isEmpty {
                            MuNodeTitleView(node: node)
                        }
                        else {
                            Image(node.icon).resizable()
                        }
                }
            }
            .onChange(of: geo.frame(in: .named("Space"))) {
                node.updateCenter($0)
            }
            .onAppear { node.updateCenter(geo.frame(in: .named("Space"))) }
        }
        .frame(width: panel.inner.width, height: panel.inner.height)
        .padding(Layout.spacing)
        .allowsHitTesting(true)
        .animation(.easeInOut(duration: Layout.animate), value: node.center)
    }
}



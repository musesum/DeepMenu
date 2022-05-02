// Created by warren on 10/1/21.

import SwiftUI

struct MuNodeView: View {

    @ObservedObject var node: MuNodeVm
    var border: MuBorder { get { node.border } }

    var body: some View {
        GeometryReader() { geo in
            Group {
                switch node {

                    case let leaf as MuLeafVm:

                        MuLeafView(leaf: leaf)

                    default:

                        if node.icon.isEmpty {
                            MuNodeTitleView(node: node)
                        }
                        else {
                            Image(node.icon).resizable()
                        }
                }
            }
            .onChange(of: geo.frame(in: .named("Space"))) { node.updateCenter($0) }
            .onAppear { node.updateCenter(geo.frame(in: .named("Space"))) }
        }
        .frame(width: border.diameter, height: border.diameter)
        .padding(Layout.spacing)
        .allowsHitTesting(true)
        .animation(.easeInOut(duration: Layout.animate), value: node.nodeXY)
    }
}



//
//  MuLeafView.swift
//  DeepMenu
//
//  Created by warren on 6/21/22.
//

import SwiftUI

struct MuLeafView<Content: View>: View {

    let leafVm: MuLeafVm
    let content: () -> Content
    var panelVm: MuPanelVm { leafVm.panelVm }

    init(_ leafVm: MuLeafVm, @ViewBuilder content: @escaping () -> Content) {
        self.leafVm = leafVm
        self.content = content
    }

    var body: some View {
        if panelVm.axis == .horizontal {
            HStack {
                if panelVm.corner.contains(.left) {
                    MuLeafBodyView(leafVm, content)
                    MuLeafTitleView(leafVm)
                } else {
                    MuLeafTitleView(leafVm)
                    MuLeafBodyView(leafVm, content)
                }
            }
        } else {
            VStack {
                MuLeafTitleView(leafVm)
                MuLeafBodyView(leafVm, content)
            }
        }
    }
}

struct MuLeafTitleView: View {

    @ObservedObject var leafVm: MuLeafVm
    var panelVm: MuPanelVm { leafVm.panelVm }

    init(_ leafVm: MuLeafVm) {
        self.leafVm = leafVm
    }
    var body: some View {
        Text(leafVm.valueText())
            .scaledToFit()
            .minimumScaleFactor(0.01)
            .foregroundColor(Color.white)
            .frame(width:  panelVm.titleSize.width,
                   height: panelVm.titleSize.height)
    }
}

struct MuLeafBodyView<Content: View>: View {

    @ObservedObject var leafVm: MuLeafVm
    let content: () -> Content
    var panelVm: MuPanelVm { leafVm.panelVm }

    init(_ leafVm: MuLeafVm,_  content:  @escaping () -> Content) {
        self.leafVm = leafVm
        self.content = content
    }
    var body: some View {
        GeometryReader { geo in
            MuPanelView(panelVm: panelVm, nodeVm: leafVm)
            content() // custom control thumb is here
        }
        .frame(width: panelVm.inner.width,
               height: panelVm.inner.height)
    }
}


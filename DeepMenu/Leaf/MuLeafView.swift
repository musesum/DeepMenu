//  Created by warren on 6/21/22.

import SwiftUI

/// Generic layout of title and control based on axis
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
                // horizontal title is farthest away from root
                // to allow control to be a bit more reachable
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
                // vertical title is always on top
                // so that hand doesn't over value text
                MuLeafTitleView(leafVm)
                MuLeafBodyView(leafVm, content)
            }
        }
    }
}

/// title showing position of control
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

/// Panel and closure(Content) for thumb of control
///
/// called by `MuLeaf*View` with only the control inside the panel
/// passed through as a closure
///
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


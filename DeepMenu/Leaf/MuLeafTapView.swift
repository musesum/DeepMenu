//  Created by warren on 5/10/22.

import SwiftUI

struct MuLeafTapView: View {

    @ObservedObject var leafVm: MuLeafTapVm
    var panelVm: MuPanelVm { leafVm.panelVm }
    
    var body: some View {
        if panelVm.axis == .horizontal {
            HStack {
                if panelVm.corner.contains(.right) {
                    MuLeafTitleView(leafVm: leafVm)
                    MuLeafBodyView(leafVm: leafVm)
                } else {
                    MuLeafBodyView(leafVm: leafVm)
                    MuLeafTitleView(leafVm: leafVm)
                }
            }
        } else {
            VStack {
                MuLeafTitleView(leafVm: leafVm)
                MuLeafBodyView(leafVm: leafVm)
            }
        }
    }
}

private struct MuLeafTitleView: View {

    @ObservedObject var leafVm: MuLeafTapVm
    var panelVm: MuPanelVm { leafVm.panelVm }

    var body: some View {
        Text(leafVm.status)
            .scaledToFit()
            .foregroundColor(Color.white)
            .frame(width: panelVm.titleSize.width,
                   height: panelVm.titleSize.height)
    }
}

private struct MuLeafBodyView: View {

    @ObservedObject var leafVm: MuLeafTapVm
    var panelVm: MuPanelVm { leafVm.panelVm }

    var body: some View {
        ZStack {
            GeometryReader { geo in
                MuPanelView(panelVm: panelVm, nodeVm: leafVm)
            }
        }
    }
}

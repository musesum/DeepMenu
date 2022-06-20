//  Created by warren on 5/10/22.

import SwiftUI

struct MuLeafVxyView: View {
    
    @ObservedObject var leafVm: MuLeafVxyVm
    var panelVm: MuPanelVm { leafVm.panelVm }
    
    var body: some View {
        VStack {
            MuLeafTitleView(leafVm: leafVm)
            MuLeafBodyView(leafVm: leafVm)
        }
    }
}

private struct MuLeafTitleView: View {

    @ObservedObject var leafVm: MuLeafVxyVm
    var panelVm: MuPanelVm { leafVm.panelVm }
    var body: some View {
        Text(leafVm.status)
            .scaledToFit()
            .minimumScaleFactor(0.01)
            .foregroundColor(Color.white)
            .frame(width: panelVm.titleSize.width,
                   height: panelVm.titleSize.height)
    }
}

private struct MuLeafBodyView: View {

    @ObservedObject var leafVm: MuLeafVxyVm
    var panelVm: MuPanelVm { leafVm.panelVm }

    var body: some View {

        ZStack {
            GeometryReader { geo in
                MuPanelView(panelVm: panelVm, nodeVm: leafVm)
                Capsule()
                    .fill(.white)
                    .frame(width: panelVm.thumbDiameter,
                           height: panelVm.thumbDiameter)
                    .offset(leafVm.offset)
                    .allowsHitTesting(false)
            }
        }
    }
}


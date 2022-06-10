// Created by warren on 10/7/21.

import SwiftUI

struct MuBranchPanelView: View {
    var panelVm: MuPanelVm
    var body: some View {
        GeometryReader { geo in
            let size = geo.frame(in: .named("Space")).size
            Rectangle()
                .opacity(0.1)
                .background(.ultraThinMaterial)
                .frame(width: size.width, height: size.height)
                .cornerRadius(panelVm.cornerRadius)
        }
    }
}

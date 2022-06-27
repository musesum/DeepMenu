// Created by warren on 10/7/21.

import SwiftUI

struct MuBranchPanelView: View {
    var panelVm: MuPanelVm
    let spotlight: Bool
    var color: Color { spotlight ? .gray : .clear }
    var width: CGFloat { spotlight ? 1 : 1 }

    var body: some View {
        GeometryReader { geo in
            let size = geo.frame(in: .named("Space")).size

            Rectangle()
                .opacity(0.1)
                .background(.ultraThinMaterial)
                .frame(width: size.width, height: size.height)
                .cornerRadius(panelVm.cornerRadius)
                .overlay(RoundedRectangle(cornerRadius: panelVm.cornerRadius)
                    .stroke(color, lineWidth: width))
                .opacity(0.5)


        }
    }
}

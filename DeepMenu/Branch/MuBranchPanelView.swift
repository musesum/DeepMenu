// Created by warren on 10/7/21.

import SwiftUI

struct MuBranchPanelView: View {
    
    var panelVm: MuPanelVm
    let spotlight: Bool
    var strokeColor: Color { spotlight ? .gray : .clear }
    var lineWidth: CGFloat { spotlight ? 1 : 1 }

    var body: some View {
        GeometryReader { geo in
            Rectangle()
                .opacity(0.1)
                .background(.ultraThinMaterial)
                .cornerRadius(panelVm.cornerRadius)
                .overlay(RoundedRectangle(cornerRadius: panelVm.cornerRadius)
                    .stroke(strokeColor, lineWidth: lineWidth))
                .opacity(0.5)
        }
    }
}

// Created by warren on 10/7/21.


import SwiftUI

struct HVScroll<Content: View>: View {
    let panelVm: MuPanelVm
    let content: () -> Content

    init(_ panel: MuPanelVm, @ViewBuilder content: @escaping () -> Content) {
        self.panelVm = panel
        self.content = content
    }

    var body: some View {
        Group {
            if panelVm.axis == .vertical {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading,
                           spacing: panelVm.margin,
                           content: content)
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .bottom,
                           spacing: panelVm.margin,
                           content: content)
                }
            }
        }
    }
}

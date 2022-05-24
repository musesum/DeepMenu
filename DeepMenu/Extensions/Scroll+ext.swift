// Created by warren on 10/7/21.


import SwiftUI

struct HVScroll<Content: View>: View {
    let panel: MuPanel
    let content: () -> Content

    init(_ panel: MuPanel, @ViewBuilder content: @escaping () -> Content) {
        self.panel = panel
        self.content = content
    }

    var body: some View {
        Group {
            if panel.axis == .vertical {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading,
                           spacing: panel.margin,
                           content: content)
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .bottom,
                           spacing: panel.margin,
                           content: content)
                }
            }
        }
    }
}

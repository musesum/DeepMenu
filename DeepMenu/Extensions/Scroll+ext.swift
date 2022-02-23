// Created by warren on 10/7/21.


import SwiftUI

struct HVScroll<Content: View>: View {
    let border: MuBorder
    let content: () -> Content

    init(_ border: MuBorder, @ViewBuilder content: @escaping () -> Content) {
        self.border = border
        self.content = content
    }

    var body: some View {
        Group {
            if border.axis == .vertical {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading,
                           spacing: border.margin,
                           content: content)
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .bottom,
                           spacing: border.margin,
                           content: content)
                }
            }
        }
    }
}

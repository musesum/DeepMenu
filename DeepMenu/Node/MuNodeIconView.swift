// Created by warren on 10/17/21.

import SwiftUI

struct MuNodeIconView: View {

    @ObservedObject var node: MuNode
    let icon: String

    var borderColor: Color { node.spotlight ? .white : .gray }
    var borderWidth: CGFloat { node.spotlight ? 2 : 1 }

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.black)
            Circle()
                .stroke(borderColor, lineWidth: borderWidth)
                .animation(.easeInOut(duration: 0.20), value: borderColor)
                .animation(.easeInOut(duration: 0.20), value: borderWidth)
                .background(Color.clear)

            Image(icon)
                .resizable()
        }
    }
}

// Created by warren on 10/17/21.

import SwiftUI

struct MuNodeIconView: View {

    @ObservedObject var node: MuNodeVm
    let icon: String

    var color: Color { node.spotlight ? .white : .black }
    var width: CGFloat { node.spotlight ? 2 : 1 }

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.black)
            Circle()
                .stroke(color, lineWidth: width)
                .animation(Layout.flash(), value: color)
                .animation(Layout.flash(), value: width)
                .background(Color.clear)

            Image(icon)
                .resizable()
        }
    }
}

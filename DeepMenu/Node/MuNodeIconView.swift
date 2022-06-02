// Created by warren on 10/17/21.

import SwiftUI

struct MuNodeIconView: View {

    @ObservedObject var nodeVm: MuNodeVm
    let icon: String

    var color: Color { nodeVm.spotlight ? .white : .black }
    var width: CGFloat { nodeVm.spotlight ? 2 : 1 }

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.black)
            Circle()
                .stroke(color, lineWidth: width)
                .animation(Layout.flashAnim, value: color)
                .animation(Layout.flashAnim, value: width)
                .background(Color.clear)

            Image(icon)
                .resizable()
        }
    }
}

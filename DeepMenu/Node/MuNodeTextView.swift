// Created by warren on 10/17/21.

import SwiftUI

struct MuNodeTextView: View {

    @ObservedObject var node: MuNodeVm
    var color: Color   { node.spotlight ? .white : .gray }
    var width: CGFloat { node.spotlight ?    2.0 :   0.5 }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: node.panelVm.cornerRadius)
                .fill(Color.black)
            RoundedRectangle(cornerRadius: node.panelVm.cornerRadius)
                .stroke(color, lineWidth: width)
                .animation(Layout.flash(), value: color)
                .animation(Layout.flash(), value: width)
                .background(Color.clear)
            Text(node.node.name)
                .scaledToFit()
                .padding(1)
                .minimumScaleFactor(0.01)
                .foregroundColor(color)
                .animation(Layout.flash(), value: color)
        }
    }
}

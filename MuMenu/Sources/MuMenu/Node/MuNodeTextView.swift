// Created by warren on 10/17/21.

import SwiftUI

struct MuNodeTextView: View {

    @ObservedObject var nodeVm: MuNodeVm
    var color: Color   { nodeVm.spotlight ? .white : .gray }
    var width: CGFloat { nodeVm.spotlight ?    2.0 :   0.5 }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: nodeVm.panelVm.cornerRadius)
                .fill(Color.black)
            RoundedRectangle(cornerRadius: nodeVm.panelVm.cornerRadius)
                .stroke(color, lineWidth: width)
                .animation(Layout.flashAnim, value: color)
                .animation(Layout.flashAnim, value: width)
                .background(Color.clear)
            Text(nodeVm.node.name)
                .scaledToFit()
                .padding(1)
                .minimumScaleFactor(0.01)
                .foregroundColor(color)
                .animation(Layout.flashAnim, value: color)
        }
    }
}

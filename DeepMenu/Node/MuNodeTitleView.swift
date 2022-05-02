// Created by warren on 10/17/21.

import SwiftUI

struct MuNodeTitleView: View {

    @ObservedObject var node: MuNodeVm
    var borderColor: Color   { node.spotlight ? .white : .gray }
    var borderWidth: CGFloat { node.spotlight ?    2.5 :   0.5 }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: node.border.cornerRadius)
                .fill(Color.black)
            RoundedRectangle(cornerRadius: node.border.cornerRadius)
                .stroke(borderColor, lineWidth: borderWidth)
                .animation(.easeInOut(duration: 0.20), value: borderColor)
                .animation(.easeInOut(duration: 0.20), value: borderWidth)
                .background(Color.clear)
            Text(node.model.name)
                .scaledToFit()
                .padding(1)
                .minimumScaleFactor(0.01)
                .foregroundColor(borderColor)
                .animation(.easeInOut(duration: 0.20), value: borderColor)
        }
    }
}

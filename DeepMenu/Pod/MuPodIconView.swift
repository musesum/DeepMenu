// Created by warren on 10/17/21.

import SwiftUI

struct MuPodIconView: View {

    @ObservedObject var pod: MuPod
    let icon: String

    var borderColor: Color { pod.spotlight ? .white : .gray }
    var borderWidth: CGFloat { pod.spotlight ? 2 : 1 }

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

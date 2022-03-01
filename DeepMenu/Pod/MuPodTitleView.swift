// Created by warren on 10/17/21.

import SwiftUI

struct MuPodTitleView: View {

    @ObservedObject var pod: MuPod
    var borderColor: Color   { pod.spotlight ? .white : .gray }
    var borderWidth: CGFloat { pod.spotlight ?    2.5 :   0.5 }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: pod.border.cornerRadius)
                .fill(Color.black)
            RoundedRectangle(cornerRadius: pod.border.cornerRadius)
                .stroke(borderColor, lineWidth: borderWidth)
                .animation(.easeInOut(duration: 0.20), value: borderColor)
                .animation(.easeInOut(duration: 0.20), value: borderWidth)
                .background(Color.clear)

            Text(pod.model.title)
                .scaledToFit()
                .padding(1)
                .minimumScaleFactor(0.01)
                .foregroundColor(borderColor)
                .animation(.easeInOut(duration: 0.20), value: borderColor)
        }
    }
}

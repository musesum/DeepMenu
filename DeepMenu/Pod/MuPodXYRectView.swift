// Created by warren on 10/17/21.

import SwiftUI

struct MuPodXYRectView: View {

    @ObservedObject var pod: MuPod
    @GestureState private var touchXY: CGPoint = .zero

    var borderColor: Color   { pod.spotlight ? .white : .gray }
    var borderWidth: CGFloat { pod.spotlight ?    2.5 :   0.5 }

    var body: some View {
        VStack {
            Text(pod.model.title)
                .scaledToFit()
                .padding(1)
                .minimumScaleFactor(0.01)
                .foregroundColor(Color.white)
                .animation(.easeInOut(duration: 0.20), value: borderColor)
            Spacer()
            GeometryReader { geo in
                RoundedRectangle(cornerRadius: pod.border.cornerRadius)
                    .fill((Color( white: 0.01, opacity: 0.5)))
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .updating($touchXY) { (value, touchXY, _) in
                                touchXY = value.location
                            }
                    )
                    .onChange(of: touchXY) { xy in
                        let value = CGPoint(x: xy.x/geo.size.width,
                                            y: xy.y/geo.size.height)
                        if value != CGPoint.zero {
                            pod.model.callback(value)
                        }
                    }
            }
        }
    }
}

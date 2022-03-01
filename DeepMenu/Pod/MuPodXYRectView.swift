// Created by warren on 10/17/21.

import SwiftUI

struct MuPodXYRectView: View {

    @ObservedObject var pod: MuPod
    @GestureState private var touchXY: CGPoint = .zero

    var borderColor: Color   { pod.spotlight ? .white : .gray }
    var borderWidth: CGFloat { pod.spotlight ?    2.5 :   0.5 }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: pod.border.cornerRadius)
                .fill(Color.black)
            GeometryReader { geo in
                RoundedRectangle(cornerRadius: pod.border.cornerRadius)
                    .stroke(borderColor, lineWidth: borderWidth)
                    .animation(.easeInOut(duration: 0.20), value: borderColor)
                    .animation(.easeInOut(duration: 0.20), value: borderWidth)
                    .background(Color.blue)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .updating($touchXY) { (value, touchXY, _) in touchXY = value.location }
                    )
                    .onChange(of: touchXY) { xyIn in
                        let xRange = geo.size.width
                        let yRange = geo.size.height
                        let value = CGPoint(x: xyIn.x / xRange, y: xyIn.y / yRange)
                        if value != CGPoint.zero {
                            pod.model.callback(value)
                        }
                    }
            }
            VStack {
                Text(pod.model.title)
                    .scaledToFit()
                    .padding(1)
                    .minimumScaleFactor(0.01)
                    .foregroundColor(Color.white)
                    .animation(.easeInOut(duration: 0.20), value: borderColor)
                Spacer()
            }
        }
    }
}

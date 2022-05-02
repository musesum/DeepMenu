// Created by warren on 10/17/21.

import SwiftUI
import Accelerate

struct MuLeafView: View {

    @ObservedObject var leaf: MuLeafVm
    @GestureState private var touchXY: CGPoint = .zero
    var border: MuBorder { get { leaf.border } }
    var borderColor: Color   { leaf.spotlight ? .white : .gray }

    var body: some View {

        VStack {
            Text(leaf.status)
                .scaledToFit()
                .foregroundColor(Color.white)
                .animation(.easeInOut(duration: 0.20), value: borderColor)
             
            ZStack {
                GeometryReader { geo in
                    RoundedRectangle(cornerRadius: leaf.border.cornerRadius)
                        .fill((Color( white: 0.01, opacity: 0.5)))
                        .frame(width: border.diameter, height: border.diameter)
                        .gesture(DragGesture(minimumDistance: 0)
                            .updating($touchXY) { (input, result, _) in result = input.location })
                        .onChange(of: touchXY) { xy in
                            let value = border.normalizeTouch(xy: xy)
                            if value != CGPoint.zero {
                                leaf.xy = value
                                // log("◘ ", [xy, leaf.xy, geo.size], format: "%.2f")
                                leaf.editing = true
                                leaf.model.callback(value)
                            } else {
                                leaf.editing = false
                            }
                        }
                    Image("icon.pearl.white")
                        .resizable()
                        .frame(width: border.thumbRadius*2, height: border.thumbRadius*2)
                        .offset(border.expandNormalized(xy: leaf.xy))
                        .allowsHitTesting(false)
                }
            }
        }
    }
}
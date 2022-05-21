//  Created by warren on 5/10/22.

import SwiftUI
import Accelerate

struct MuLeafVxyView: View {

    @ObservedObject var leafVm: MuLeafVxyVm
    @GestureState private var touchXY: CGPoint = .zero
    @EnvironmentObject var root: MuRootVm
    var border: MuBorder { get { leafVm.border } }
    var borderColor: Color   { leafVm.spotlight ? .white : .gray }

    var body: some View {

        VStack {
            Text(leafVm.status)
                .scaledToFit()
                .foregroundColor(Color.white)
                .animation(.easeInOut(duration: 0.20), value: borderColor)
            ZStack {
                GeometryReader { geo in
                    RoundedRectangle(cornerRadius: leafVm.border.cornerRadius)
                        .fill((Color( white: 0.01, opacity: 0.5)))
                        .frame(width: border.inner.width, height: border.inner.height)
                        .gesture(DragGesture(minimumDistance: 0)
                            .updating($touchXY) { (input, result, _) in
                                result = input.location })
                        .onChange(of: touchXY) { xy in
                            leafVm.touching(root.touch.touching, xy) }
                    Capsule()
                        .fill(.white)
                        .frame(width: border.thumbRadius*2, height: border.thumbRadius*2)
                        .offset(leafVm.offset)
                        .allowsHitTesting(false)
                }
            }
        }
    }
}

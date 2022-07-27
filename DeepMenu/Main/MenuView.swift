//  Created by warren on 6/11/22.


import SwiftUI
import MuMenu

struct MenuView: View {

    @GestureState private var touchXY: CGPoint = .zero
    let menuVm: MenuVm

    var body: some View {

        MuRootView()
            .environmentObject(menuVm.rootVm)
            .coordinateSpace(name: "Canvas")
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .named("Canvas"))
                .updating($touchXY) { (value, touchXY, _) in touchXY = value.location })
            .onChange(of: touchXY) { menuVm.rootVm.touchVm.touchUpdate($0) }
            //?? .defersSystemGestures(on: .vertical)
    }
}

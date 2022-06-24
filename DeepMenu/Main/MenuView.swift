//  Created by warren on 6/11/22.


import SwiftUI

struct MenuView: View {

    @GestureState private var touchXY: CGPoint = .zero
    let menuVm: MenuVm

    var body: some View {

        MuRootView().environmentObject(menuVm.rootVm)
            .coordinateSpace(name: "Space")
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .named("Space"))
                .updating($touchXY) { (value, touchXY, _) in touchXY = value.location })
            .onChange(of: touchXY) { menuVm.rootVm.touchVm.touchUpdate($0) }
            //?? .defersSystemGestures(on: .vertical)
    }
}

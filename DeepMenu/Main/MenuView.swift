//  Created by warren on 6/11/22.


import SwiftUI

struct MenuView: View {
    @GestureState private var touchXY: CGPoint = .zero
    let vm: MenuVm
    var body: some View {
        MuRootView().environmentObject(vm.rootVm)
            .coordinateSpace(name: "Space")
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .named("Space"))
                .updating($touchXY) { (value, touchXY, _) in touchXY = value.location })
            .onChange(of: touchXY) { vm.rootVm.touchVm.touchUpdate($0) }
    }
}

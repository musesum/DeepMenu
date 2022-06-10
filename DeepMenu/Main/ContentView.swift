// Created 9/26/21.

import SwiftUI

/**
 ContentView.main is only used to remove annoying `taskbar`
 by adding HostingController to AppPortDelegates
    - note: TODO: remove this if Apple fixes
 */
struct ContentViews {
    static let main = ContentView()
    static let client = ExampleClientView()
}

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

struct ContentView: View {

    @GestureState private var touchXY: CGPoint = .zero
                    let appSpace = AppSpace()

    var body: some View {
        // ContentViews.client
        ZStack(alignment: .bottomLeading) {
            BackView(space: appSpace)
            MenuView(vm: SkyVm(corner: [.lower, .left]))
            MenuView(vm: SkyVm(corner: [.lower, .right]))
            //MenuView(vm: TestVm(corner: [.upper, .right]))
        }
        .statusBar(hidden: true)

    }
}

#if false
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView.shared
            .environment(\.colorScheme, .dark)
    }
}
#endif


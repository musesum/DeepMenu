// Created 9/26/21.

import SwiftUI

struct ContentView: View {
    
    let appSpace = AppSpace()

    var body: some View {
        // ContentView())
        ZStack(alignment: .bottomLeading) {
            BackView(space: appSpace)
            MenuView(menuVm: SkyVm(corner: [.lower, .left], axis: .vertical))
            MenuView(menuVm: SkyVm(corner: [.upper, .left], axis: .horizontal))
            //MenuView(menuVm: SkyVm(corner: [.lower, .right], axis: .vertical))
            //MenuView(menuVm: SkyVm(corner: [.upper, .right], axis: .horizontal))
            MenuView(menuVm: TestVm(corner: [.lower, .right]))
            MenuView(menuVm: TestVm(corner: [.upper, .right]))
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


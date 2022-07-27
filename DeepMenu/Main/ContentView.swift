// Created 9/26/21.

import SwiftUI
import MuMenu

struct ContentView: View {
    
    var body: some View {
        // ContentView())
        ZStack(alignment: .bottomLeading) {
            CanvasView()
            MenuView(menuVm: SkyVm(corner: [.lower, .left], axis: .vertical))
            MenuView(menuVm: SkyVm(corner: [.lower, .right], axis: .vertical))
            
            //MenuView(menuVm: SkyVm(corner: [.upper, .left], axis: .horizontal))
            //MenuView(menuVm: SkyVm(corner: [.upper, .right], axis: .horizontal))
            //MenuView(menuVm: SkyVm(corner: [.lower, .right], axis: .vertical))
            //MenuView(menuVm: SkyVm(corner: [.upper, .right], axis: .horizontal))
            //MenuView(menuVm: TestVm(corner: [.upper, .left]))
            //MenuView(menuVm: TestVm(corner: [.upper, .right]))
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


// Created 9/26/21.

import SwiftUI
import MuMenu
import MuMenuSky

struct ContentView: View {
    
    var body: some View {
        // ContentView())
        ZStack(alignment: .bottomLeading) {
            CanvasView()
            MenuView(menuVm: MenuSkyVm(corner: [.lower, .left], axis: .vertical, rootTr3: nil))
            MenuView(menuVm: MenuSkyVm(corner: [.lower, .right], axis: .vertical, rootTr3: nil))
            
            //MenuView(menuVm: MenuSkyVm(corner: [.upper, .left], axis: .horizontal))
            //MenuView(menuVm: MenuSkyVm(corner: [.upper, .right], axis: .horizontal))
            //MenuView(menuVm: MenuSkyVm(corner: [.lower, .right], axis: .vertical))
            //MenuView(menuVm: MenuSkyVm(corner: [.upper, .right],n axis: .horizontal))
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


// Created 9/26/21.

import SwiftUI

/**
 ContentView.main is only used to remove annoying `taskbar`
 by adding HostingController to AppPortDelegates
    - note: TODO: remove this if Apple fixes
 */
struct ContentViews {
    static let main = ContentView()
}

struct ContentView: View {

    let hub1 = MuHub([.lower, .right])
    let hub2 = MuHub([.lower, .left ])
    let hub3 = MuHub([.upper, .right])
    let hub4 = MuHub([.upper, .left ])

    var body: some View {
        ZStack(alignment: .bottomLeading) {

            MuSpaceView(space: MuSpace())
            MuHubView().environmentObject(hub1)
//            MuHubView().environmentObject(hub2)
//            MuHubView().environmentObject(hub3)
//            MuHubView().environmentObject(hub4)
        }
        .coordinateSpace(name: "Space")
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


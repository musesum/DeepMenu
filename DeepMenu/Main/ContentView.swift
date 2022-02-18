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

    var body: some View {
        ZStack(alignment: .bottomLeading) {

            AppBackgroundView(space: MuSpace())

            MuHubView().environmentObject(MuHub([.lower, .right]))
//            MuHubView().environmentObject(MuHub([.lower, .left ]))
//            MuHubView().environmentObject(MuHub([.upper, .right]))
//            MuHubView().environmentObject(MuHub([.upper, .left ]))
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


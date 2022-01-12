// Created 9/26/21.

import SwiftUI

/**

Naming convention

    Mu<name>View - Always a SwiftUI View
    Mu<name>Model - A persistent model of pods, shared by Mu<name> views
    Mu<name> - ObservableObject companion to a Mu<name>View

    The <name> views follows a hierarchy of

        Space - where content and menues are

        Hub - Corner of Space that contains one or two Spokes
            each spoke is aligned horizonal or vertical

        Spoke - a hierarchy of stacked Docks
            vSpoke instance - a static hierarchy of Docks for vert
            hSpoke instance - a dynamic history of vert

        Dock - contains one or more Pods
            stacked in levels of increasing detail

        Pod - an individual item to select
            spotPod - spotlight pod highlighted in bar

        Pilot - follows your finger/thumb/pencil to select Pods and stack Docks

        Border - Border and bounds for dock

Programming convention

    Views don't own Pods, Docks, Spoke, or Hub,
        which may be synchroniozed accross devices,
        like iPhone, iDock, TV, watch, shareplay
    So, no @State or @StateObjects are used
        Keep View(s) as functions, which down own source of truth
        Instead, use a 1:1 class:struct Mu<name>:Mu<name>View
 */

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
    // let hub2 = MuHub([.lower, .left ])
    // let hub3 = MuHub([.upper, .right])
    // let hub4 = MuHub([.upper, .left ])

    var body: some View {
        ZStack(alignment: .bottomLeading) {

            MuSpaceView(space: MuSpace())
            MuHubView().environmentObject(hub1)
            // MuHubView().environmentObject(hub2)
            // MuHubView().environmentObject(hub3)
            // MuHubView().environmentObject(hub4)
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


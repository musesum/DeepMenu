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

struct ContentView: View {
    let appSpace = AppSpace()

    var body: some View {
        ContentViews.client
        ZStack(alignment: .bottomLeading) {
            AppBackgroundView(space: appSpace)


            MuHubView().environmentObject(MuHub([.lower, .right], docks: defaultSampleDocks()))
            MuHubView().environmentObject(MuHub([.lower, .left ], docks: appControlDocks()))
             MuHubView().environmentObject(MuHub([.upper, .right], docks: defaultSampleDocks()))
//            MuHubView().environmentObject(MuHub([.upper, .left ], docks: defaultSampleDocks()))
        }
        .coordinateSpace(name: "Space")
        .statusBar(hidden: true)
    }
    
    private func defaultSampleDocks() -> [MuDock] {
        let numberedPods = ExamplePodModels.numberedPods(5, numLevels: 5)
        let letteredPods = ExamplePodModels.letteredPods()
        let hDock  = MuDock(subModels: numberedPods, axis: .horizontal)
        let vDock  = MuDock(subModels: letteredPods, axis: .vertical)
        return [hDock, vDock]
    }
    
    private func appControlDocks() -> [MuDock] {
        let colorModel = MuPodModel("Color")
        colorModel.addChild(MuPodModel("Red") { _ in
            appSpace.backgroundColor = Color(red: 0.2, green: 0.0, blue: 0.0, opacity: 1.00) })
        colorModel.addChild(MuPodModel("Green") { _ in
            appSpace.backgroundColor = Color(red: 0.0, green: 0.2, blue: 0.0, opacity: 1.00) })
        colorModel.addChild(MuPodModel("Blue") { _ in
            appSpace.backgroundColor = Color(red: 0.0, green: 0.0, blue: 0.2, opacity: 1.00) })

        let clientModel = MuPodModel("Client")
        clientModel.addChild(MuPodModel("One") { _ in ContentViews.client.model.path = "One" })
        clientModel.addChild(MuPodModel("Two") { _ in ContentViews.client.model.path = "Two" })
        clientModel.addChild(MuPodModel("Three") { _ in ContentViews.client.model.path = "Three" })

        let clientXY = MuPodModel("Client XY")
        clientXY.addChild(MuPodModel("Client XY", type: .rect) { xy in
            if let xy = xy as? CGPoint {
                ContentViews.client.model.path = "Client XY"
                ContentViews.client.model.x = xy.x
                ContentViews.client.model.y = xy.y
            }
        })
        clientModel.addChild(clientXY)

        let vDock  = MuDock(subModels: [colorModel, clientModel], axis: .vertical)
        return [vDock]
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


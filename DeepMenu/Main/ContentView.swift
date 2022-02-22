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
    let muSpace = MuSpace()

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AppBackgroundView(space: muSpace)

            MuHubView().environmentObject(MuHub([.lower, .right], docks: defaultSampleDocks()))
            MuHubView().environmentObject(MuHub([.lower, .left ], docks: appControlDocks()))
//            MuHubView().environmentObject(MuHub([.upper, .right], docks: defaultSampleDocks()))
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
        let backgroundPodModel = MuPodModel("BG")
        backgroundPodModel.addChild(MuPodModel("R--") { muSpace.color = Color(red: 0.2, green: 0.0, blue: 0.0, opacity: 1.00) })
        backgroundPodModel.addChild(MuPodModel("-G-") { muSpace.color = Color(red: 0.0, green: 0.2, blue: 0.0, opacity: 1.00) })
        backgroundPodModel.addChild(MuPodModel("--B") { muSpace.color = Color(red: 0.0, green: 0.0, blue: 0.2, opacity: 1.00) })
//        backgroundPodModel.addChild(MuPodModel(.xyInput) { xy in print("bg xy position \(xy)") })

        let borderPodModel = MuPodModel("BDR")
        borderPodModel.addChild(MuPodModel("R--") { print("red border selected") })
        borderPodModel.addChild(MuPodModel("-G-") { print("green border selected") })
        borderPodModel.addChild(MuPodModel("--B") { print("blue border selected") })
//        borderPodModel.addChild(MuPodModel(.xyInput) { xy in print("border xy position \(xy)") })

        let vDock  = MuDock(subModels: [backgroundPodModel, borderPodModel], axis: .vertical)
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


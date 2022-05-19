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
            MuRootView().environmentObject(MuRootVm([.lower, .right], branches: testBranches()))
            MuRootView().environmentObject(MuRootVm([.lower, .left ], branches: skyBranches()))
        }
        .coordinateSpace(name: "Space")
        .statusBar(hidden: true)
    }

    private func skyBranches() -> [MuBranchVm] {
        let skyNodes = ExampleTr3Sky.skyNodes()
        let skyBranches = MuBranchVm(children: skyNodes, axis: .vertical)
        return [skyBranches]
    }
    private func testBranches() -> [MuBranchVm] {
        let numberedNodes = ExampleNodeModels.numberedNodes(5, numLevels: 5)
        let letteredNodes = ExampleNodeModels.letteredNodes()
        let hBranch = MuBranchVm(children: numberedNodes, axis: .horizontal)
        let vBranch = MuBranchVm(children: letteredNodes, axis: .vertical)
        return [hBranch, vBranch]
    }
    
    private func appControlBranches() -> [MuBranchVm] {
        let colorModel = MuNodeTest("Color")
        colorModel.addChild(MuNodeTest("Red") { _ in
            appSpace.backgroundColor = Color(red: 0.2, green: 0.0, blue: 0.0, opacity: 1.00) })
        colorModel.addChild(MuNodeTest("Green") { _ in
            appSpace.backgroundColor = Color(red: 0.0, green: 0.2, blue: 0.0, opacity: 1.00) })
        colorModel.addChild(MuNodeTest("Blue") { _ in
            appSpace.backgroundColor = Color(red: 0.0, green: 0.0, blue: 0.2, opacity: 1.00) })

        let clientModel = MuNodeTest("Client")
        clientModel.addChild(MuNodeTest("One") { _ in ContentViews.client.model.path = "One" })
        clientModel.addChild(MuNodeTest("Two") { _ in ContentViews.client.model.path = "Two" })
        clientModel.addChild(MuNodeTest("Three") { _ in ContentViews.client.model.path = "Three" })

        let clientXY = MuNodeTest("Client XY")
        clientXY.addChild(MuNodeTest("Client XY", type: .vxy) { xy in
            if let xy = xy as? CGPoint {
                ContentViews.client.model.path = "Client XY"
                ContentViews.client.model.x = xy.x
                ContentViews.client.model.y = xy.y
            }
        })
        clientModel.addChild(clientXY)

        let vBranch  = MuBranchVm(children: [colorModel, clientModel], axis: .vertical)
        return [vBranch]
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


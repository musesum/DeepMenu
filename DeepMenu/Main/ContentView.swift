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

class ContentVm {

    var skyNodes: [MuNode]
    var skyTouchVm: MuTouchVm
    var skyRootVm: MuRootVm
    var skyTreeVm: MuTreeVm?
    var skyBranchVm: MuBranchVm

    init() {
        // init in sequence: nodes, root, tree, branch, touch
        skyNodes = ExampleTr3Sky.skyNodes()
        skyRootVm = MuRootVm([.lower, .left], axii: [.vertical])
        skyTreeVm = skyRootVm.treeNowVm
        skyBranchVm = MuBranchVm(children: skyNodes, tree: skyTreeVm)
        skyTreeVm?.addBranch(skyBranchVm)
        skyTouchVm = skyRootVm.touchVm
    }
    
    private func testBranches(_ tree: MuTreeVm) -> [MuBranchVm] {
        let numberedNodes = ExampleNodeModels.numberedNodes(5, numLevels: 5)
        let letteredNodes = ExampleNodeModels.letteredNodes()
        let hBranch = MuBranchVm(children: numberedNodes, tree: tree) //?? axis: .horizontal)
        let vBranch = MuBranchVm(children: letteredNodes, tree: tree) //?? axis: .vertical)
        return [hBranch, vBranch]
    }
}

struct ContentView: View {
    let appSpace = AppSpace()
    let contentVm = ContentVm()

    var body: some View {
        // ContentViews.client
        ZStack(alignment: .bottomLeading) {
            AppBackgroundView(space: appSpace)
            //MuRootView().environmentObject(MuRootVm([.lower, .right], branches: testBranches()))
            MuRootView().environmentObject(contentVm.skyRootVm)
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


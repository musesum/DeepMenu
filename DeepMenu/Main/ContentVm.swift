//  Created by warren on 6/4/22.

import SwiftUI

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
        skyTreeVm = skyRootVm.treeSpotVm
        skyBranchVm = MuBranchVm(nodes: skyNodes, treeVm: skyTreeVm)
        skyTreeVm?.branchVms.append(skyBranchVm)
        skyTouchVm = skyRootVm.touchVm
    }

    private func testBranches(_ treeVm: MuTreeVm) -> [MuBranchVm] {
        let numberNodes = ExampleNodeModels.numberedNodes(5, numLevels: 5)
        let letterNodes = ExampleNodeModels.letteredNodes()
        let numberBranch = MuBranchVm.cached(nodes: numberNodes, treeVm: treeVm)
        let letterBranch = MuBranchVm.cached(nodes: letterNodes, treeVm: treeVm)
        let branches = [numberBranch, letterBranch]
        return branches
    }
}

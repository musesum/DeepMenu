//  Created by warren on 6/4/22.

import SwiftUI

class ContentVm {

    var skyRootVm: MuRootVm
    var testRootVm: MuRootVm

    init() {
        // init in sequence: nodes, root, tree, branch, touch
        let skyTreeVm = MuTreeVm(axis: .vertical)
        let skyNodes = ExampleTr3Sky.skyNodes()
        let skyBranchVm = MuBranchVm(nodes: skyNodes, treeVm: skyTreeVm)
        skyTreeVm.addBranchVms([skyBranchVm])

        skyRootVm = MuRootVm([.lower, .left], treeVms: [skyTreeVm])
        testRootVm = makeTestRootVm()
    }
}

func makeTestRootVm () -> MuRootVm {
    let letterTreeVm = MuTreeVm(axis: .vertical)
    let letterNodes = ExampleNodeModels.letteredNodes()
    let letterBranchVm = MuBranchVm(nodes: letterNodes, treeVm: letterTreeVm)
    letterTreeVm.addBranchVms([letterBranchVm])

    let numberTreeVm = MuTreeVm(axis: .horizontal)
    let numberNodes = ExampleNodeModels.numberedNodes(5, numLevels: 5)
    let numberBranchVm = MuBranchVm(nodes: numberNodes, treeVm: numberTreeVm)
    numberTreeVm.addBranchVms([numberBranchVm])

    let treeVms = [letterTreeVm, numberTreeVm]

    return MuRootVm([.lower, .right], treeVms: treeVms)
}

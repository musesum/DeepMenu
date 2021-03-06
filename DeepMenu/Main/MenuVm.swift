//  Created by warren on 6/4/22.

import SwiftUI
import MuMenu

class MenuVm {
    var rootVm: MuRootVm
    init(_ rootVm: MuRootVm) {
        self.rootVm = rootVm
    }
}


class TestVm: MenuVm {

    init(corner: MuCorner) {

        let letterTreeVm = MuTreeVm(axis: .vertical, corner: corner)
        let letterNodes = ExampleNodeModels.letteredNodes()
        let letterBranchVm = MuBranchVm(nodes: letterNodes, treeVm: letterTreeVm)
        letterTreeVm.addBranchVms([letterBranchVm])

        let numberTreeVm = MuTreeVm(axis: .horizontal, corner: corner)
        let numberNodes = ExampleNodeModels.numberedNodes(5, numLevels: 5)
        let numberBranchVm = MuBranchVm(nodes: numberNodes, treeVm: numberTreeVm)
        numberTreeVm.addBranchVms([numberBranchVm])

        let treeVms = [letterTreeVm, numberTreeVm]

        super.init(MuRootVm(corner, treeVms: treeVms))
    }
}

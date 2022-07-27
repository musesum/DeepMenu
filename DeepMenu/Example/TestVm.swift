//
//  TestVm.swift
//  DeepMenu
//
//  Created by warren on 7/27/22.
//

import SwiftUI
import MuMenu

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

//
//  SkyVm.swift
//  DeepMenu
//
//  Created by warren on 7/27/22.
//

import SwiftUI
import MuMenu

class SkyVm: MenuVm {

    static let Nodes = ExampleTr3Sky.skyNodes() // shared between instances

    init(corner: MuCorner, axis: Axis) {

        // init in sequence: nodes, root, tree, branch, touch
        let skyTreeVm = MuTreeVm(axis: axis, corner: corner)
        let skyBranchVm = MuBranchVm(nodes: SkyVm.Nodes, treeVm: skyTreeVm)
        skyTreeVm.addBranchVms([skyBranchVm])
        super.init(MuRootVm(corner, treeVms: [skyTreeVm]))
    }
}

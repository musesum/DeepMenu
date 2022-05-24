// Created by warren on 10/17/21.

import SwiftUI

class MuNodeVm: Identifiable, Equatable, ObservableObject {
    let id = MuIdentity.getId()

    static func == (lhs: MuNodeVm, rhs: MuNodeVm) -> Bool {
        return lhs.id == rhs.id
    }

    @Published var spotlight = false // true when selected or under cursor
    var spotTime = TimeInterval(0)

    var node: MuNode            // each model MuNode maybe on several MuNodeVm(s)
    var icon: String            // icon for this node (not implemented)
    var branch: MuBranchVm      // branch that this node is on
    var parentVm: MuNodeVm?     // parent branch's spotlight node
    var center = CGPoint.zero   // current position
    var panel: MuPanel

    @Published var editing: Bool = false   // changing value of leaf (or order of node, later)

    init (_ type: MuNodeType,
          _ branch: MuBranchVm,
          _ node: MuNode,
          _ spotPrev: MuNodeVm? = nil,
          icon: String = "") {

        self.branch = branch
        self.node = node
        self.icon = icon
        self.parentVm = spotPrev
        self.panel = MuPanel(type: type)

        if [.val, .vxy].contains(type) {
            branch.panel.type = type
        }
    }
    
    func copy() -> MuNodeVm {
        let node = MuNodeVm(panel.type, branch, node, self, icon: icon)
        return node
    }

    /// spotlight self, parent, grand, etc. in branch
    func superSpotlight(_ time: TimeInterval = Date().timeIntervalSince1970) {
        for node in branch.branchNodes {
            node.spotlight = false
        }
        spotlight = true
        spotTime = time
        parentVm?.superSpotlight(time)
    }

    /// select self, parent, grand, etc. in branch
    func superSelect() {

        if let spotPrev = parentVm {
            spotPrev.spotlight = true
            spotPrev.node.childNow = node
            spotPrev.superSelect()
        }
    }

    func updateCenter(_ fr: CGRect) {
        center = CGPoint(x: fr.origin.x + fr.size.width/2,
                         y: fr.origin.y + fr.size.height/2)
    }

}

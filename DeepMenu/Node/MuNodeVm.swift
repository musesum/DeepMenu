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
    var spotParent: MuNodeVm?   // parent branch's spotlight node
    var nodeXY = CGPoint.zero   // current position

    var border: MuBorder

    init (_ type: MuNodeType,
          _ branch: MuBranchVm,
          _ node: MuNode,
          icon: String = "",
          spotPrev: MuNodeVm? = nil) {

        self.branch = branch
        self.node = node
        self.icon = icon
        self.spotParent = spotPrev
        self.border = MuBorder(type: type)

        if [.dial, .box].contains(type) {
            branch.border.type = type
        }
    }
    
    func copy() -> MuNodeVm {
        let node = MuNodeVm(border.type, branch, node, icon: icon, spotPrev: self)
        return node
    }

    /// spotlight self, parent, grand, etc. in branch
    func superSpotlight(_ time: TimeInterval = Date().timeIntervalSince1970) {
        for node in branch.branchNodes {
            node.spotlight = false
        }
        spotlight = true
        spotTime = time
        spotParent?.superSpotlight(time)
    }

    /// select self, parent, grand, etc. in branch
    func superSelect() {

        if let spotPrev = spotParent {
            spotPrev.spotlight = true
            spotPrev.node.childNow = node
            spotPrev.superSelect()
        }
    }

    func updateCenter(_ fr: CGRect) {

        let center = CGPoint(x: fr.origin.x + fr.size.width/2,
                             y: fr.origin.y + fr.size.height/2)
        nodeXY = center
    }

    
}

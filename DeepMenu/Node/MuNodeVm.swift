// Created by warren on 10/17/21.

import SwiftUI

class MuNodeVm: Identifiable, Equatable, ObservableObject {
    let id = MuIdentity.getId()

    static func == (lhs: MuNodeVm, rhs: MuNodeVm) -> Bool {
        return lhs.id == rhs.id
    }

    @Published var spotlight = false // true when selected or under cursor
    var spotTime = TimeInterval(0)

    var model: MuNodeModel      // each model MuNodeModel maybe on several MuNode(s)
    var icon: String            // icon for this node (not implemented)
    var branch: MuBranchVm        // branch that this node is on
    var spotPrev: MuNodeVm?       // parent branch's spotlight node
    var subNodes: [MuNodeVm]      // sub nodes (child nodes)
    var nodeXY = CGPoint.zero   // current position

    var border: MuBorder

    init (_ type: MuNodeType,
          _ branch: MuBranchVm,
          _ model: MuNodeModel,
          icon: String = "",
          spotPrev: MuNodeVm? = nil,
          subNodes: [MuNodeVm] = []) {

        self.branch = branch
        self.model = model
        self.icon = icon
        self.spotPrev = spotPrev
        self.subNodes = subNodes
        self.border = MuBorder(type: type)

        if [.knob, .boxy].contains(type) {
            branch.border.type = type
        }

        for subModel in model.children {
            let subNode = MuNodeVm(type, branch, subModel, spotPrev: self)
            self.subNodes.append(subNode)
        }
    }
    
    func copy() -> MuNodeVm {
        let node = MuNodeVm(border.type,
                          branch,
                          model,
                          icon: icon,
                          spotPrev: self,
                          subNodes: subNodes)
        return node
    }

    /// spotlight self, parent, grand, etc. in branch
    func superSpotlight(_ time: TimeInterval = Date().timeIntervalSince1970) {
        for node in branch.branchNodes {
            node.spotlight = false
        }
        spotlight = true
        spotTime = time
        spotPrev?.superSpotlight(time)
    }

    /// select self, parent, grand, etc. in branch
    func superSelect() {

        if let spotPrev = spotPrev {
            spotPrev.spotlight = true
            spotPrev.model.subNow = model
            spotPrev.superSelect()
        }
    }

    func updateCenter(_ fr: CGRect) {

        let center = CGPoint(x: fr.origin.x + fr.size.width/2,
                             y: fr.origin.y + fr.size.height/2)
        nodeXY = center
    }

    
}
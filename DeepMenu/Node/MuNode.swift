// Created by warren on 10/17/21.

import SwiftUI

class MuNode: Identifiable, Equatable, ObservableObject {
    let id = MuIdentity.getId()

    static func == (lhs: MuNode, rhs: MuNode) -> Bool {
        return lhs.id == rhs.id
    }

    @Published var spotlight = false // true when selected or under cursor
    var spotTime = TimeInterval(0)

    var model: MuNodeModel
    var icon: String
    var branch: MuBranch
    var suprNode: MuNode?   // super node
    var subNodes: [MuNode]  // sub nodes
    var nodeXY = CGPoint.zero // current position

    var border: MuBorder

    init (_ type: MuBorderType,
          _ branch: MuBranch,
          _ model: MuNodeModel,
          icon: String = "",
          suprNode: MuNode? = nil,
          subNodes: [MuNode] = []) {

        self.branch = branch
        self.model = model
        self.icon = icon
        self.suprNode = suprNode
        self.subNodes = subNodes
        self.border = MuBorder(type: type)

        if [.polar, .rect].contains(type) {
            branch.border.type = type
        }

        for subModel in model.subModels {
            let subNode = MuNode(type, branch, subModel, suprNode: self)
            self.subNodes.append(subNode)
        }
    }
    
    func copy() -> MuNode {
        let node = MuNode(border.type,
                        branch,
                        model,
                        icon: icon,
                        suprNode: self,
                        subNodes: subNodes)
        return node
    }

    /// spotlight self, parent, grand, etc. in branch
    func superSpotlight(_ time: TimeInterval = Date().timeIntervalSince1970) {
        for node in branch.subNodes {
            node.spotlight = false
        }
        spotlight = true
        spotTime = time
        suprNode?.superSpotlight(time)
    }

    /// select self, parent, grand, etc. in branch
    func superSelect() {

        if let suprNode = suprNode {
            suprNode.spotlight = true
            suprNode.model.subNow = model
            suprNode.superSelect()
        }
    }

    func updateCenter(_ fr: CGRect) {

        let center = CGPoint(x: fr.origin.x + fr.size.width/2,
                             y: fr.origin.y + fr.size.height/2)
        nodeXY = center
    }

    
}

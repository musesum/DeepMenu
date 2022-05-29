// Created by warren on 10/17/21.

import SwiftUI

extension MuNodeVm {

    static func cache(_ type: MuNodeType,
                      _ node: MuNode,
                      _ branchVm: MuBranchVm,
                      _ parentVm: MuNodeVm? = nil,
                      icon: String = "") -> MuNodeVm {

        switch type {
            case .val: return MuLeafValVm(node, branchVm, parentVm)
            case .vxy: return MuLeafVxyVm(node, branchVm, parentVm)
            case .tog: return MuLeafTogVm(node, branchVm, parentVm)
            case .tap: return MuLeafTapVm(node, branchVm, parentVm)
            case .seg: return MuLeafSegVm(node, branchVm, parentVm)
            default:   return MuNodeVm(type, node, branchVm, parentVm)
        }
    }
}
extension MuNodeVm {

    func path() -> String {
        if let prior = parentVm?.path() {
            return prior + "." + node.name
        } else {
            return node.name
        }
    }

    func path(child: String) -> String {
        let prior = path()
        if prior.isEmpty {
            return child
        } else {
            return prior + "." + child
        }
    }

    func hash() -> Int {
        let path = path()
        var hasher = Hasher()
        hasher.combine(path)
        let hash = hasher.finalize()
        //print(path + String(format: ": %i", hash))
        return hash
    }

    func hash(child: String) -> Int {
        let path = path(child: child)
        var hasher = Hasher()
        hasher.combine(path)
        let hash = hasher.finalize()
        print(path + String(format: ": %i", hash))
        return hash
    }
}


class MuNodeVm: Identifiable, Equatable, ObservableObject {
    let id = MuIdentity.getId()
    static func == (lhs: MuNodeVm, rhs: MuNodeVm) -> Bool { return lhs.id == rhs.id }

    @Published var spotlight = false // true when selected or under cursor
    var spotTime = TimeInterval(0)

    var type: MuNodeType        // node, val, vxy, seg, tog, tap
    var node: MuNode            // each model MuNode maybe on several MuNodeVm(s)
    var icon: String            // icon for this node (not implemented)
    var branchVm: MuBranchVm    // branch that this node is on
    var parentVm: MuNodeVm?     // parent branch's spotlight node
    var center = CGPoint.zero   // current position
    var panelVm: MuPanelVm

    var components: [String: Any]? { get {
        (node as? MuNodeTr3)?.tr3.components() ?? [:]
    }}
    @Published var editing: Bool = false // changing value of leaf (or order of node, later)

    init (_ type: MuNodeType,
          _ node: MuNode,
          _ branch: MuBranchVm,
          _ parentVm: MuNodeVm? = nil,
          icon: String = "") {

        self.node = node
        self.type = type
        self.branchVm = branch
        self.icon = icon
        self.parentVm = parentVm
        self.panelVm = MuPanelVm(type: type)

        if [.val, .vxy].contains(type) {
            branch.panelVm.type = type
        }
    }
    
    func copy() -> MuNodeVm {
        let node = MuNodeVm(panelVm.type, node, branchVm, self, icon: icon)
        return node
    }

    /// spotlight self, parent, grand, etc. in branch
    func superSpotlight(_ time: TimeInterval = Date().timeIntervalSince1970) {
        for nodeVm in branchVm.nodeVms {
            nodeVm.spotlight = false
        }
        spotlight = true
        spotTime = time
        parentVm?.superSpotlight(time)
    }

    /// select self, parent, grand, etc. in branch
    func superSelect() {

        if let parentVm = parentVm {
            parentVm.spotlight = true
            parentVm.node.childNow = node
            parentVm.superSelect()
        }
    }

    func updateCenter(_ fr: CGRect) {
        center = CGPoint(x: fr.origin.x + fr.size.width/2,
                         y: fr.origin.y + fr.size.height/2)
    }

}

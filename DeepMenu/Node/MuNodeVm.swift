// Created by warren on 10/17/21.

import SwiftUI


class MuNodeVm: Identifiable, Equatable, ObservableObject {
    let id = MuIdentity.getId()
    static func == (lhs: MuNodeVm, rhs: MuNodeVm) -> Bool { return lhs.id == rhs.id }

    /// publish changing value of leaf (or order of node, later)
    @Published var editing: Bool = false
    /// publish when selected or is under cursor
    @Published var spotlight = false

    let type: MuNodeType      // node, val, vxy, seg, tog, tap
    let node: MuNode          // each model MuNode maybe on several MuNodeVm's
    let icon: String?         // icon for this node (not implemented)
    var branchVm: MuBranchVm  // branch that this node is on
    var superVm: MuNodeVm?    // parent nodeVm in hierarchy
    var subVms = [MuNodeVm]() // child nodeVm's in hierarchy
    var center = CGPoint.zero // current position
    var panelVm: MuPanelVm

    var components: [String: Any]? { get {
        (node as? MuNodeTr3)?.tr3.components() ?? [:]
    }}

    init (_ type: MuNodeType,
          _ node: MuNode,
          _ branchVm: MuBranchVm,
          _ superVm: MuNodeVm? = nil,
          icon: String? = nil) {

        self.type = type
        self.node = node
        self.branchVm = branchVm
        self.superVm = superVm
        self.icon = icon
        self.panelVm = MuPanelVm(type: type)

        superVm?.subVms.append(self)
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
        superVm?.superSpotlight(time)
    }

    /// select self, parent, grand, etc. in branch
    func superSelect() {

        if let parentVm = superVm {
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
        if let prior = superVm?.path() {
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


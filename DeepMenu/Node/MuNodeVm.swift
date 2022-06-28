// Created by warren on 10/17/21.

import SwiftUI

class MuNodeVm: Identifiable, Equatable, ObservableObject {
    let id =  MuIdentity.getId()
    static func == (lhs: MuNodeVm, rhs: MuNodeVm) -> Bool { return lhs.id == rhs.id }

    /// publish changing value of leaf (or order of node, later)
    @Published var editing: Bool = false

    /// publish when selected or is under cursor
    @Published var spotlight = false

    func publishChanged(spotlight nextSpotlight: Bool) {
        if spotlight != nextSpotlight {
            spotlight = nextSpotlight
        }
    }

    let type: MuNodeType      /// node, val, vxy, seg, tog, tap
    let node: MuNode          /// each model MuNode maybe on several MuNodeVm's
    let icon: String?         /// icon for this node (not implemented)
    var branchVm: MuBranchVm /// branch that this node is on
    var nextBranchVm: MuBranchVm? /// branch this node generates

    var leafVm: MuNodeVm?     /// optional MuLeaf for editing value
    var prevVm: MuNodeVm?     /// parent nodeVm in hierarchy
    var panelVm: MuPanelVm

    var center = CGPoint.zero /// current position

    init (_ type: MuNodeType,
          _ node: MuNode,
          _ branchVm: MuBranchVm,
          _ prevVm: MuNodeVm? = nil,
          icon: String? = nil) {

        self.type = type
        self.node = node
        self.branchVm = branchVm
        self.prevVm = prevVm
        self.icon = icon
        self.panelVm = MuPanelVm(type: type,
                                 treeVm: branchVm.treeVm)
        prevVm?.nextBranchVm = branchVm
    }
    
    func copy() -> MuNodeVm {
        let nodeVm = MuNodeVm(panelVm.type, node, branchVm, self, icon: icon)
        return nodeVm
    }

    /// spotlight self, parent, grand, etc. in branch
    func superSpotlight() {
        if branchVm.nodeSpotVm != self {

            branchVm.nodeSpotVm?.spotlight = false
            branchVm.nodeSpotVm = self
            branchVm.show = true
            spotlight = true
        }
        prevVm?.superSpotlight()
    }

    func updateCenter(_ fr: CGRect) {
        center = CGPoint(x: fr.origin.x + fr.size.width/2,
                         y: fr.origin.y + fr.size.height/2)
    }

    func contains(_ point: CGPoint) -> Bool {
        center.distance(point) < Layout.diameter
    }

    /// evenly space branches leading up to current branch's position
    func refreshBranch() {

        superSpotlight()
        branchVm.expandBranch()
        branchVm.treeVm.refreshTree(branchVm)
    }
}
extension MuNodeVm {
    
    static func cached(_ type: MuNodeType,
                       _ node: MuNode,
                       _ branchVm: MuBranchVm,
                       _ prevVm: MuNodeVm? = nil,
                       icon: String = "") -> MuNodeVm {

        switch type {
            case .val: return MuLeafValVm(node, branchVm, prevVm)
            case .vxy: return MuLeafVxyVm(node, branchVm, prevVm)
            case .tog: return MuLeafTogVm(node, branchVm, prevVm)
            case .tap: return MuLeafTapVm(node, branchVm, prevVm)
            case .seg: return MuLeafSegVm(node, branchVm, prevVm)
            default:   return MuNodeVm(type, node, branchVm, prevVm)
        }
    }
}

extension MuNodeVm {

    func path() -> String {
        if let prior = prevVm?.path() {
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
        //print(path + String(format: ": %i", hash))
        return hash
    }
}

extension MuNodeVm: Hashable {

    public func hash(into hasher: inout Hasher) {
        let path = path()
        hasher.combine(path)
        _ = hasher.finalize()
        //print(path + String(format: ": %i", result))
    }

}

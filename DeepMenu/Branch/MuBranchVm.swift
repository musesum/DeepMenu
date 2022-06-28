// Created by warren on 10/16/21.

import SwiftUI


class MuBranchVm: Identifiable, ObservableObject {
    let id = MuIdentity.getId()
    static func == (lhs: MuBranchVm, rhs: MuBranchVm) -> Bool { lhs.id == rhs.id }
    static func == (lhs: MuBranchVm, rhs: MuBranchVm?) -> Bool { lhs.id == (rhs?.id ?? -1) }

    @Published var show = true

    var treeVm: MuTreeVm       /// my tree; which unfolds a hierarchy of branches
    var nodeVms: [MuNodeVm]    /// all the node View Models on this branch
    var nodeSpotVm: MuNodeVm?  /// current node, nodeSpotVm.branchVm is next branch
    var panelVm: MuPanelVm     /// background + stroke model for BranchView

    var isRoot: Bool = false
    var bounds: CGRect = .zero
    var boundsPad: CGRect = .zero /// extended bounds for capturing finger drag
    var level: CGFloat = 0     /// zIndex within sub/super branches
    var reverse = false        /// show in reverse order

    var title: String {
        let nameFirst = nodeVms.first?.node.name ?? ""
        let nameLast  = nodeVms.last?.node.name ?? ""
        return nameFirst + "…" + nameLast
    }

    init(nodes: [MuNode] = [],
         treeVm: MuTreeVm,
         type: MuNodeType = .node,
         prevNodeVm: MuNodeVm? = nil,
         level: CGFloat = 0) {

        self.nodeVms = []
        self.treeVm = treeVm
        self.level = level
        self.isRoot = nodes.count == 0

        self.panelVm = MuPanelVm(type: type,
                                 count: nodes.count,
                                 treeVm: treeVm)
        buildNodeVms(from: nodes,
                     type: type,
                     prevNodeVm: prevNodeVm)

        updateTree(treeVm)
    }

    private func buildNodeVms(from nodes: [MuNode],
                              type: MuNodeType,
                              prevNodeVm: MuNodeVm?) {

        for node in nodes {
            let nodeVm = MuNodeVm.cached(type, node, self, prevNodeVm)
            nodeVms.append(nodeVm)
            if nodeVm.type.isLeaf {
                prevNodeVm?.leafVm = nodeVm // is leaf of previous (parent) node
                nodeSpotVm = nodeVm
            }
            else if nodeVm.spotlight {
                nodeSpotVm = nodeVm
            }
        }
    }
    
   
    /// add a branch to selected node and follow next node
    func expandBranch() {
        guard let nodeSpotVm = nodeSpotVm else { return }

        if let leafVm = nodeSpotVm.leafVm {
            leafVm.branchVm.expandBranch()
        }
        else if let leafType = nodeSpotVm.node.leafType() {
            
            let leafNode = MuNode(name: "✎ ",
                                  parent: nodeSpotVm.node)
            
            _ = MuBranchVm
                .cached(nodes: [leafNode],
                        treeVm: treeVm,
                        type: leafType,
                        prevNodeVm: nodeSpotVm,
                        level: level + 1)
        }
        else if nodeSpotVm.node.children.count > 0 {
            
            let newBranchVm = MuBranchVm
                .cached(nodes: nodeSpotVm.node.children,
                        treeVm: treeVm,
                        type: .node,
                        prevNodeVm: nodeSpotVm,
                        level: level+1)
            
            newBranchVm.expandBranch()
        }
    }

    func skipBranches() -> Bool {
        if nodeSpotVm?.nextBranchVm?.nodeSpotVm != nil {
            // log("👶", terminator: "")
            return true
        } else {
            return false
        }

    }

/**
 May be updated after init for root tree inside update Root
     */
    func updateTree(_ treeVm: MuTreeVm?) {
        guard let treeVm = treeVm else { return }
        self.treeVm = treeVm
        if let center = nodeSpotVm?.prevVm?.center {
            bounds = panelVm.getBounds(from: center)
            boundsPad = bounds + Layout.padding
        }
    }

    func addNodeVm(_ nodeVm: MuNodeVm?) {
        guard let nodeVm = nodeVm else { return }
        if nodeVms.contains(nodeVm) { return }
        nodeVms.append(nodeVm)
    }


    func findNearestNode(_ touchNow: CGPoint) -> MuNodeVm? {

        // is hovering over same node as before
        if nodeSpotVm?.contains(touchNow) ?? false {
            return nodeSpotVm
        }
        for nodeVm in nodeVms {
            if nodeVm.center.distance(touchNow) < Layout.diameter {
                nodeSpotVm?.spotlight = false
                nodeSpotVm = nodeVm
                nodeSpotVm?.spotlight = true
                nodeVm.superSpotlight()
                return nodeVm
            }
        }
        return nil
    }
    
    /// check touch point is inside a leaf's branch
    ///
    ///  - note: already checked inclide a leaf's runway
    ///  so expand check to inlude the title area
    func findNearestLeaf(_ touchNow: CGPoint) -> MuLeafVm? {

        // is hovering over same node as before
        if let leafVm = nodeSpotVm as? MuLeafVm,
           leafVm.branchVm.bounds.contains(touchNow) {
            return leafVm
        }
        for nodeVm in nodeVms {
            if let leafVm = nodeVm as? MuLeafVm,
               leafVm.branchVm.bounds.contains(touchNow) {
                nodeSpotVm = leafVm
                nodeSpotVm?.spotlight = true
                leafVm.superSpotlight()
                return leafVm
            }
        }
        return nil
    }

    func updateBounds(_ from: CGRect) {
        if bounds != from {
            bounds = panelVm.updateBounds(from)
            boundsPad = bounds + Layout.padding
        }
    }
}

var BranchCache = [Int: MuBranchVm]()

extension MuBranchVm {
    
    static func cached(nodes: [MuNode] = [],
                       treeVm: MuTreeVm,
                       type: MuNodeType = .node,
                       prevNodeVm: MuNodeVm? = nil,
                       level: CGFloat = 0) -> MuBranchVm {

        func nextHash() -> Int {
            var hasher = Hasher()
            hasher.combine(prevNodeVm?.hashValue ?? 0)
            hasher.combine(treeVm.rootVm?.corner.rawValue ?? 0)
            hasher.combine(type.icon)
            let hash = hasher.finalize()
            return hash
        }

        let nextHash = nextHash()
        if let oldBranch = BranchCache[nextHash] {
            // print("🧺 ", terminator: "")
            return oldBranch
        }
        let newBranch = MuBranchVm(
            nodes: nodes,
            treeVm: treeVm,
            type: type,
            prevNodeVm: prevNodeVm,
            level: level)

        BranchCache[nextHash] = newBranch

        return newBranch
    }
}


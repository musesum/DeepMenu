// Created by warren on 10/16/21.

import SwiftUI


class MuBranchVm: Identifiable, ObservableObject {
    let id = MuIdentity.getId()

    var isRoot: Bool = false
    var tree: MuTreeVm?          // my tree; which unfolds a hierarchy of branches
    var level: CGFloat = 0       // zIndex within sub/super branches

    var branchPrev: MuBranchVm?  // branch preceding this one
    var branchNext: MuBranchVm?  // branch expanding from spotlight node
    var nodeVms: [MuNodeVm]     // the nodes on this branch, incl spotNode

    var nodeNowVm: MuNodeVm?      // current spotlight node
    var nodePrevVm: MuNodeVm?      // prevBranch's spotlight node

    var panelVm: MuPanelVm
    var bounds: CGRect = .zero

    @Published var branchShift: CGSize = .zero
    @Published var show = true

    var reverse = false

    init(branchPrev: MuBranchVm? = nil,
         branchNodes: [MuNodeVm] = [],
         tree: MuTreeVm?,
         isRoot: Bool = false,
         show: Bool = true) {

        self.branchPrev = branchPrev
        self.nodeVms = branchNodes
        self.tree = tree
        self.level = (branchPrev?.level ?? 0) + 1
        self.isRoot = isRoot
        self.show = show
        let axis = tree?.axis ?? .vertical
        self.panelVm = MuPanelVm(type: .node, count: branchNodes.count, axis: axis)

        branchPrev?.branchNext = self
        updateLimb(tree)
    }

    init(branchPrev: MuBranchVm? = nil,
         spotPrev: MuNodeVm? = nil,
         children: [MuNode],
         tree: MuTreeVm?,
         show: Bool = true) {

        self.branchPrev = branchPrev
        self.nodePrevVm = spotPrev
        self.nodeVms = [MuNodeVm]()
        self.tree = tree
        self.level = (branchPrev?.level ?? 0) + 1
        self.show = show
        let axis = tree?.axis ?? .vertical
        self.panelVm = MuPanelVm(type: .node, count: children.count, axis: axis)

        branchPrev?.branchNext = self

        buildNodesFromChildren(spotPrev, children)
        updateLimb(tree)
    }

    init(branchPrev: MuBranchVm? = nil,
         tree: MuTreeVm,
         type: MuNodeType) {

        self.branchPrev = branchPrev
        self.tree = tree
        self.level = (branchPrev?.level ?? 0) + 1
        self.nodeVms = [MuNodeVm]()
        self.panelVm = MuPanelVm(type: type, axis: tree.axis)
    }
    deinit {
        // print("\n🗑\(title)(\(id))", terminator: "")=
    }


    private func buildNodesFromChildren(_ spotPrevVm: MuNodeVm?,
                                        _ children: [MuNode]) {

        for child in children {

            let nodeVm = MuNodeVm.cache(.node, child, self, spotPrevVm)
            nodeVms.append(nodeVm)

            if let components = nodeVm.components,
               let type = components["type"] as? MuNodeType,
               type.isLeaf {

                let leafNode = MuNode(name: nodeVm.node.name, parent: nodeVm.node, callback: nodeVm.node.callback)
                let branchVm = MuBranchVm(branchPrev: self,
                                          children: [leafNode],
                                          tree: tree,
                                          show: false)
                let leafVm = MuNodeVm.cache(type, leafNode, branchVm)
                branchVm.nodeVms.append(leafVm)
            }

        }
        return
    }

    /**
     May be updated after init for root tree inside updateRoot
     */
    func updateLimb(_ tree: MuTreeVm?) {

        guard let tree = tree else { return }
        self.tree = tree

        if let center = branchPrev?.nodeNowVm?.center {
            bounds = panelVm.bounds(center)
        }
        branchShift = branchPrev?.branchShift ?? .zero
    }

    func addNode(_ nodeVm: MuNodeVm?) {
        guard let nodeVm = nodeVm else { return }
        if nodeVms.contains(nodeVm) { return }
        nodeVms.append(nodeVm)
    }
    
    func removeNode(_ node: MuNodeVm) {
        let filtered = nodeVms.filter { $0.id != node.id }
        nodeVms = filtered
    }

    func findHover(_ touchNow: CGPoint) -> MuNodeVm? {

        // not hovering over branch? 
        if !bounds.contains(touchNow) {
            //TODO: return nil has false positives
        }

        //TODO: this is rather inefficient, is a workaround for the above
        for nodeVm in nodeVms {
            let threshold = Layout.diameter + Layout.spacing
            if nodeVm.center.distance(touchNow) < threshold {
                nodeNowVm = nodeVm
                nodeVm.superSpotlight()
                return nodeVm
            }
        }
        return nil
    }

    func beginTap() {

        if let nodeNowVm = nodeNowVm {
            nodeNowVm.superSelect()
            tree?.refreshBranches(nodeNowVm)
        }
    }

    func updateBounds(_ from: CGRect) {
        if bounds != from {
            bounds = panelVm.updateBounds(from)
            // log("∿" + title, from, bounds)
        }
    }
}

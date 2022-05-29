// Created by warren on 10/16/21.

import SwiftUI


class MuBranchVm: Identifiable, ObservableObject {
    let id = MuIdentity.getId()

    var treeVm: MuTreeVm?           // my tree; which unfolds a hierarchy of branches
    var branchPrevVm: MuBranchVm?   // branch preceding this one
    var nodeVms: [MuNodeVm]         // all the node view models on this branch
    var nodeNowVm: MuNodeVm?        // current node on hierarcy sequence
    var panelVm: MuPanelVm

    var isRoot: Bool = false
    var bounds: CGRect = .zero
    var level: CGFloat = 0          // zIndex within sub/super branches

    @Published var branchShift: CGSize = .zero
    @Published var show = true

    var reverse = false

    init(branchPrev: MuBranchVm? = nil,
         branchNodes: [MuNodeVm] = [],
         treeVm: MuTreeVm?,
         isRoot: Bool = false,
         show: Bool = true) {

        self.branchPrevVm = branchPrev
        self.nodeVms = branchNodes
        self.treeVm = treeVm
        self.level = (branchPrev?.level ?? 0) + 1
        self.isRoot = isRoot
        self.show = show
        let axis = treeVm?.axis ?? .vertical
        self.panelVm = MuPanelVm(type: .node, count: branchNodes.count, axis: axis)
        updateTree(treeVm)
    }

    init(branchPrevVm: MuBranchVm? = nil,
         nodeNowVm: MuNodeVm? = nil,
         children: [MuNode],
         treeVm: MuTreeVm?,
         show: Bool = true) {

        self.branchPrevVm = branchPrevVm
        self.nodeVms = [MuNodeVm]()
        self.treeVm = treeVm
        self.level = (branchPrevVm?.level ?? 0) + 1
        self.show = show
        let axis = treeVm?.axis ?? .vertical
        self.panelVm = MuPanelVm(type: .node, count: children.count, axis: axis)
        buildNodesFromChildren(nodeNowVm, children)
        updateTree(treeVm)
    }

    init(branchPrev: MuBranchVm? = nil,
         treeVm: MuTreeVm?,
         type: MuNodeType) {

        self.branchPrevVm = branchPrev
        self.treeVm = treeVm
        self.level = (branchPrev?.level ?? 0) + 1
        self.nodeVms = [MuNodeVm]()
        let axis = treeVm?.axis ?? .vertical
        self.panelVm = MuPanelVm(type: type, axis: axis)
    }

    private func buildNodesFromChildren(_ spotPrevVm: MuNodeVm?,
                                        _ children: [MuNode]) {

        for child in children {

            let nodeVm = MuNodeVm.cache(.node, child, self, spotPrevVm)
            nodeVms.append(nodeVm)

            if let components = nodeVm.components,
               let type = components["type"] as? MuNodeType,
               type.isLeaf {

                let leafNode = MuNode(name: "✎"+nodeVm.node.name, parent: nodeVm.node, callback: nodeVm.node.callback)
                let branchVm = MuBranchVm(branchPrev: self,
                                          treeVm: treeVm,
                                          type: type)
                let leafVm = MuNodeVm.cache(type, leafNode, branchVm)
                branchVm.nodeVms.append(leafVm)
            }

        }
        return
    }

    /**
     May be updated after init for root tree inside updateRoot
     */
    func updateTree(_ treeVm: MuTreeVm?) {

        guard let treeVm = treeVm else { return }
        self.treeVm = treeVm

        if let center = branchPrevVm?.nodeNowVm?.center {
            bounds = panelVm.bounds(center)
        }
        branchShift = branchPrevVm?.branchShift ?? .zero
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

    func findNearestNode(_ touchNow: CGPoint) -> MuNodeVm? {

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
            treeVm?.refreshBranches(nodeNowVm)
        }
    }

    func updateBounds(_ from: CGRect) {
        if bounds != from {
            bounds = panelVm.updateBounds(from)
            // log("∿" + title, from, bounds)
        }
    }
}

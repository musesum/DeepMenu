// Created by warren on 10/16/21.

import SwiftUI


class MuBranchVm: Identifiable, ObservableObject {
    let id = MuIdentity.getId()

    var treeVm: MuTreeVm?     /// my tree; which unfolds a hierarchy of branches
    var nodeVms: [MuNodeVm]   /// all the node view models on this branch
    var nodeSpotVm: MuNodeVm? /// current node, nodeSpotVm.branchVm is next branch
    var panelVm: MuPanelVm

    var isRoot: Bool = false
    var bounds: CGRect = .zero
    var level: CGFloat = 0    /// zIndex within sub/super branches
    var reverse = false       /// show in reverse order

    @Published var branchShift: CGSize = .zero
    @Published var show = true

    init(nodes: [MuNode] = [],
         treeVm: MuTreeVm?,
         type: MuNodeType,
         level: CGFloat = 0) {

        self.nodeVms = []
        self.treeVm = treeVm
        self.level = level
        self.isRoot = nodes.count == 0

        self.panelVm = MuPanelVm(type: .node,
                                 count: nodes.count,
                                 axis: treeVm?.axis ?? .vertical)
        buildFromNodes(nodes)
        updateTree(treeVm)
    }

    private func buildFromNodes(_ nodes: [MuNode]) {

        for node in nodes {
            let nodeVm = MuNodeVm.cache(.node, node, self, nodeSpotVm)
            nodeVms.append(nodeVm)
            if nodeVm.spotlight {
                nodeSpotVm = nodeVm
            }
        }
    }
    
    /// evenly space branches leading up to current branch's position
    func refreshBranch(_ nodeNextVm: MuNodeVm?) {
        
        if nodeSpotVm?.id != nodeNextVm?.id {
            nodeSpotVm?.spotlight = false
            nodeSpotVm = nodeNextVm
            nodeSpotVm?.spotlight = true
        }
        if nodeSpotVm?.branchVm.show == true {
            expandBranch()
            treeVm?.refreshTree(self)
        }
    }

    /** add a branch to selected node and follow next node


     */
    private func expandBranch() {

        guard let nodeSpotVm = nodeSpotVm else { return }
        nodeSpotVm.spotlight = true

        let nextType = nodeSpotVm.components?["type"] as? MuNodeType ?? .node


        if nodeSpotVm.node.children.count > 0 {
            let newBranch = MuBranchVm(nodes: nodeSpotVm.node.children,
                                       treeVm: treeVm,
                                       type: .node,
                                       level: level+1)

            nodeSpotVm.branchVm = newBranch

            if newBranch.nodeSpotVm?.spotlight ?? false {
                newBranch.expandBranch()
            }
        } else if nextType.isLeaf {

            let leafNode = MuNode(name: "✎",
                                  parent: nodeSpotVm.node,
                                  callback: nodeSpotVm.node.callback)

            let branchVm = MuBranchVm(nodes: [leafNode],
                                      treeVm: treeVm,
                                      type: nextType,
                                      level: level+1)
            
            nodeSpotVm.branchVm = branchVm
        }
    }

    /**
     May be updated after init for root tree inside updateRoot
     */
    func updateTree(_ treeVm: MuTreeVm?) {
        guard let treeVm = treeVm else { return }

        self.treeVm = treeVm

        if let center = nodeSpotVm?.superVm?.center {
            bounds = panelVm.bounds(center)
        }
        branchShift = nodeSpotVm?.superVm?.branchVm.branchShift ?? .zero
    }

    func addNode(_ nodeVm: MuNodeVm?) {
        guard let nodeVm = nodeVm else { return }
        if nodeVms.contains(nodeVm) { return }
        nodeVms.append(nodeVm)
    }

    func findNearestNode(_ touchNow: CGPoint) -> MuNodeVm? {

        // is hovering over same node as before
        if (nodeSpotVm?.center.distance(touchNow) ?? .infinity) < Layout.diameter {
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

    func beginTap(_ nearestNode: MuNodeVm) {
        nodeSpotVm = nearestNode
        nearestNode.superSelect()
        refreshBranch(nearestNode)
    }

    func updateBounds(_ from: CGRect) {
        if bounds != from {
            bounds = panelVm.updateBounds(from)
            // log("∿" + title, from, bounds)
        }
    }
}
extension MuBranchVm {
    func cached(nodes: [MuNode] = [],
                nodeVms: [MuNodeVm] = [],
                treeVm: MuTreeVm?,
                isRoot: Bool = false,
                type: MuNodeType = .node,
                level: CGFloat = 0,
                show: Bool = true) -> MuBranchVm
    {
        let newBranch = MuBranchVm(
            nodes: nodes,
            treeVm: treeVm,
            type: type,
            level: level)
        return newBranch
    }
}

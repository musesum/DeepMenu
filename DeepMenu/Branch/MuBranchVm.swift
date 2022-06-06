// Created by warren on 10/16/21.

import SwiftUI


class MuBranchVm: Identifiable, ObservableObject {
    let id = MuIdentity.getId()

    @Published var branchShift: CGSize = .zero
    @Published var show = true

    var treeVm: MuTreeVm?       /// my tree; which unfolds a hierarchy of branches
    var nodeVms: [MuNodeVm]     /// all the node View Models on this branch
    var nodeSpotVm: MuNodeVm?   /// current node, nodeSpotVm.branchVm is next branch
    var prevBranch: MuBranchVm? /// previous (super) branch to this one
    var nextBranch: MuBranchVm? /// next (sub) branch to this one
    var panelVm: MuPanelVm

    var isRoot: Bool = false
    var bounds: CGRect = .zero
    var level: CGFloat = 0    /// zIndex within sub/super branches
    var reverse = false       /// show in reverse order

    var title: String {
        let nameFirst = nodeVms.first?.node.name ?? ""
        let nameLast  = nodeVms.last?.node.name ?? ""
        return nameFirst + "…" + nameLast
    }


    init(nodes: [MuNode] = [],
         treeVm: MuTreeVm?,
         type: MuNodeType,
         prevVm: MuNodeVm? = nil,
         level: CGFloat = 0) {

        self.nodeVms = []
        self.treeVm = treeVm
        self.level = level
        self.isRoot = nodes.count == 0

        self.panelVm = MuPanelVm(type: type,
                                 count: nodes.count,
                                 axis: treeVm?.axis ?? .vertical)
        buildNodeVms(from: nodes,
                     type: type,
                     prevVm: prevVm)

        updateTree(treeVm)
    }

    private func buildNodeVms(from nodes: [MuNode],
                              type: MuNodeType,
                              prevVm: MuNodeVm?) {

        for node in nodes {
            let nodeVm = MuNodeVm.cache(type, node, self, prevVm)
            nodeVms.append(nodeVm)
            if nodeVm.type.isLeaf {
                prevVm?.leafVm = nodeVm // is leaf of previous (parent) node
                nodeSpotVm = nodeVm
            }
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
        if nodeSpotVm?.type.isLeaf == true {
            print("🍁")
        }
        else if nodeSpotVm?.branchVm?.show == true {
            expandBranch()
            treeVm?.refreshTree(self)
        }
    }

    /// add a branch to selected node and follow next node

    private func expandBranch() {

        guard let nodeSpotVm = nodeSpotVm else { return }
        nodeSpotVm.spotlight = true


        if let leafVm = nodeSpotVm.leafVm {
            leafVm.branchVm?.expandBranch()
        }

        else if let nextType = nodeSpotVm.components?["type"] as? MuNodeType,
            nextType.isLeaf {

            let leafNode = MuNode(name: "✎",
                                  parent: nodeSpotVm.node,
                                  callback: nodeSpotVm.node.callback)
            
            let newBranchVm = MuBranchVm(nodes: [leafNode],
                                         treeVm: treeVm,
                                         type: nextType,
                                         prevVm: nodeSpotVm,
                                         level: level+1)

            nextBranch = newBranchVm
            nextBranch?.prevBranch = self
        }
        else if nodeSpotVm.node.children.count > 0 {

            let newBranchVm = MuBranchVm(nodes: nodeSpotVm.node.children,
                                         treeVm: treeVm,
                                         type: .node,
                                         level: level+1)

            nextBranch = newBranchVm
            nextBranch?.prevBranch = self
            nextBranch?.expandBranch()
        }
    }


    /**
     May be updated after init for root tree inside updateRoot
     */
    func updateTree(_ treeVm: MuTreeVm?) {
        guard let treeVm = treeVm else { return }

        self.treeVm = treeVm

        if let center = nodeSpotVm?.prevVm?.center {
            bounds = panelVm.getBounds(from: center)
        }
        branchShift = nodeSpotVm?.prevVm?.branchVm?.branchShift ?? .zero
    }

    func addNodeVm(_ nodeVm: MuNodeVm?) {
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
        nearestNode.superSpotlight()
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

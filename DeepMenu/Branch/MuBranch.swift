// Created by warren on 10/16/21.

import SwiftUI


class MuBranch: Identifiable, ObservableObject {
    let id = MuIdentity.getId()

    var isRoot: Bool = false
    var limb: MuLimb?           // my limb; which unfolds a hierarchy of branches
    var level: CGFloat          // zIndex within sub/super branches

    var branchPrev: MuBranch?   // branch preceding this one
    var branchNext: MuBranch?   // branch expanding from spotlight node
    var branchNodes: [MuNode]    // the nodes on this branch, incl spotNode

    var spotNode: MuNode?       // current spotlight node
    var spotPrev: MuNode?       // prevBranch's spotlight node

    var border: MuBorder
    var bounds: CGRect = .zero
    @Published var branchShift: CGSize = .zero
    @Published var show = true

    var reverse = false

    init(branchPrev: MuBranch? = nil,
         branchNodes: [MuNode] = [],
         limb: MuLimb? = nil,
         level: CGFloat = 0,
         isRoot: Bool = false,
         show: Bool = true,
         axis: Axis) {

        self.branchPrev = branchPrev
        self.branchNodes = branchNodes
        self.limb = limb
        self.level = level
        self.isRoot = isRoot
        self.show = show
        self.border = MuBorder(type: .node, count: branchNodes.count, axis: axis)

        branchPrev?.branchNext = self
        updateLimb(limb)
    }

    init(branchPrev: MuBranch? = nil,
         spotPrev: MuNode? = nil,
         children: [MuNodeModel],
         limb: MuLimb? = nil,
         level: CGFloat = 0,
         show: Bool = true,
         axis: Axis) {

        self.branchPrev = branchPrev
        self.spotPrev = spotPrev
        self.branchNodes = [MuNode]()
        self.limb = limb
        self.level = level
        self.show = show
        
        self.border = MuBorder(type: .node, count: children.count, axis: axis)

        branchPrev?.branchNext = self

        buildNodesFromChildren(children)
        updateLimb(limb)
    }
    
    deinit {
        // print("\n🗑\(title)(\(id))", terminator: "")=
    }

    /// leaf node should be a xy rectangle control
    private func buildNodesFromChildren(_ children: [MuNodeModel]) {
        for child in children {
            var node: MuNode
            switch child.nodeType {
                case .node, .none:
                    node = MuNode(child.nodeType, self, child, spotPrev: spotPrev)
                default:
                    node = MuLeaf(child.nodeType, self, child, spotPrev: spotPrev)
            }
            branchNodes.append(node)
        }
    }
    /**
     May be updated after init for root limb inside updateRoot
     */
    func updateLimb(_ limb: MuLimb?) {

        guard let limb = limb else { return }
        self.limb = limb

        if let center = branchPrev?.spotNode?.nodeXY {
            bounds = border.bounds(center)
        }
        branchShift = branchPrev?.branchShift ?? .zero
    }

    func addNode(_ node: MuNode) {
        if branchNodes.contains(node) { return }
        branchNodes.append(node)
    }
    
    func removeNode(_ node: MuNode) {
        let filtered = branchNodes.filter { $0.id != node.id }
        branchNodes = filtered
    }

    func findHover(_ touchNow: CGPoint) -> MuNode? {

        // not hovering over branch? 
        if !bounds.contains(touchNow) {
            //TODO: return nil has false positives
        }

        //TODO: this is rather inefficient, is a workaround for the above
        for node in branchNodes {

            if node.nodeXY.distance(touchNow) < border.diameter {
                spotNode = node
                node.superSpotlight()
                return node
            }
        }
        return nil
    }

    func beginTap() {

        if let spotNode = spotNode {
            spotNode.superSelect()
            limb?.refreshBranches(self, spotNode)
        }
    }

    func updateBounds(_ from: CGRect) {
        if bounds != from {
            bounds = border.updateBounds(from)
            // log("∿" + title, from, bounds)
        }
    }
}

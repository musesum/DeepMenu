// Created by warren on 10/16/21.

import SwiftUI


class MuBranchVm: Identifiable, ObservableObject {
    let id = MuIdentity.getId()

    var isRoot: Bool = false
    var limb: MuLimbVm?           // my limb; which unfolds a hierarchy of branches
    var level: CGFloat          // zIndex within sub/super branches

    var branchPrev: MuBranchVm?   // branch preceding this one
    var branchNext: MuBranchVm?   // branch expanding from spotlight node
    var branchNodes: [MuNodeVm]    // the nodes on this branch, incl spotNode

    var spotNode: MuNodeVm?       // current spotlight node
    var spotPrev: MuNodeVm?       // prevBranch's spotlight node

    var border: MuBorder
    var bounds: CGRect = .zero
    @Published var branchShift: CGSize = .zero
    @Published var show = true

    var reverse = false

    init(branchPrev: MuBranchVm? = nil,
         branchNodes: [MuNodeVm] = [],
         limb: MuLimbVm? = nil,
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

    init(branchPrev: MuBranchVm? = nil,
         spotPrev: MuNodeVm? = nil,
         children: [MuNode],
         limb: MuLimbVm? = nil,
         level: CGFloat = 0,
         show: Bool = true,
         axis: Axis) {

        self.branchPrev = branchPrev
        self.spotPrev = spotPrev
        self.branchNodes = [MuNodeVm]()
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
    private func buildNodesFromChildren(_ children: [MuNode]) {
        for child in children {
            var node: MuNodeVm
            switch child.nodeType {
                case .node, .none:
                    node = MuNodeVm(child.nodeType, self, child, spotPrev: spotPrev)
                default:
                    node = MuLeafVm(child.nodeType, self, child, spotPrev: spotPrev)
            }
            branchNodes.append(node)
        }
    }
    /**
     May be updated after init for root limb inside updateRoot
     */
    func updateLimb(_ limb: MuLimbVm?) {

        guard let limb = limb else { return }
        self.limb = limb

        if let center = branchPrev?.spotNode?.nodeXY {
            bounds = border.bounds(center)
        }
        branchShift = branchPrev?.branchShift ?? .zero
    }

    func addNode(_ node: MuNodeVm) {
        if branchNodes.contains(node) { return }
        branchNodes.append(node)
    }
    
    func removeNode(_ node: MuNodeVm) {
        let filtered = branchNodes.filter { $0.id != node.id }
        branchNodes = filtered
    }

    func findHover(_ touchNow: CGPoint) -> MuNodeVm? {

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

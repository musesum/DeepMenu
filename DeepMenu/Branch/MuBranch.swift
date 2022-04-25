// Created by warren on 10/16/21.

import SwiftUI


class MuBranch: Identifiable, ObservableObject {
    let id = MuIdentity.getId()

    let title: String
    var isRoot: Bool = false

    var limb: MuLimb?       // my limb; which unfolds a hierarchy of branches
    var level: CGFloat      // zIndex within sub/super branches

    var prevBranch: MuBranch?   // super branch preceding this one
    var nextBranch: MuBranch?   // sub branch expanding from spotlight node
    var suprNode: MuNode?     // super branch's spotlight node
    var subNodes: [MuNode]    // the nodes on this branch, incl spotNode
    var spotNode: MuNode?     // current spotlight node

    var border: MuBorder
    var bounds: CGRect = .zero
    @Published var branchShift: CGSize = .zero
    @Published var show = true

    var reverse = false

    init(prevBranch: MuBranch? = nil,
         subNodes: [MuNode] = [],
         limb: MuLimb? = nil,
         level: CGFloat = 0,
         isRoot: Bool = false,
         show: Bool = true,
         axis: Axis) {

        self.prevBranch = prevBranch
        self.subNodes = subNodes
        self.limb = limb
        self.title = "\(subNodes.first?.model.title ?? "")…\(subNodes.last?.model.title ?? "")"
        self.level = level
        self.isRoot = isRoot
        self.show = show
        self.border = MuBorder(type: .branch, count: subNodes.count, axis: axis)

        prevBranch?.nextBranch = self
        updateLimb(limb)
    }

    init(prevBranch: MuBranch? = nil,
         suprNode: MuNode? = nil,
         children: [MuNodeModel],
         limb: MuLimb? = nil,
         level: CGFloat = 0,
         show: Bool = true,
         axis: Axis) {

        self.prevBranch = prevBranch
        self.suprNode = suprNode
        self.subNodes = [MuNode]()
        self.limb = limb
        self.level = level
        self.title = "\(children.first?.title ?? "")…\(children.last?.title ?? "")"
        self.show = show
        
        self.border = MuBorder(type: .branch, count: children.count, axis: axis)

        prevBranch?.nextBranch = self

        buildNodesFromChildren(children)
        updateLimb(limb)
    }
    
    deinit {
        // print("\n🗑\(title)(\(id))", terminator: "")=
    }

    // TODO: This should probably be done at the app level, as the app should be deciding e.g. if the
    //       leaf node should be a xy rectangle control
    private func buildNodesFromChildren(_ children: [MuNodeModel]) {
        for child in children {
            var node: MuNode
            if children.count > 1 || child.children.count > 0 {
                node = MuNode(child.borderType, self, child, suprNode: suprNode)
            } else {
                node = MuLeaf(child.borderType, self, child, suprNode: suprNode)
            }
            subNodes.append(node)
        }
    }
    /**
     May be updated after init for root limb inside updateRoot
     */
    func updateLimb(_ limb: MuLimb?) {

        guard let limb = limb else { return }
        self.limb = limb

        if let center = prevBranch?.spotNode?.nodeXY {
            bounds = border.bounds(center)
        }
        branchShift = prevBranch?.branchShift ?? .zero
    }

    func addNode(_ node: MuNode) {
        if subNodes.contains(node) { return }
        subNodes.append(node)
    }
    
    func removeNode(_ node: MuNode) {
        let filtered = subNodes.filter { $0.id != node.id }
        subNodes = filtered
    }

    func findHover(_ touchNow: CGPoint) -> MuNode? {

        // not hovering over branch? 
        if !bounds.contains(touchNow) {
            //TODO: return nil has false positives
        }

        //TODO: this is rather inefficient, is a workaround for the above
        for node in subNodes {

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
            //?? log("∿" + title, from, bounds)
        }
    }
}

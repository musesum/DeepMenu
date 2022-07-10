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

    var branchPrev: MuBranchVm?
    var boundsNow: CGRect = .zero /// current bounds after shifting
    var boundsPad: CGRect = .zero /// extended bounds for capturing finger drag
    var level: CGFloat = 0        /// zIndex within sub/super branches

    var title: String {
        let nameFirst = nodeVms.first?.node.name ?? ""
        let nameLast  = nodeVms.last?.node.name ?? ""
        return nameFirst + "…" + nameLast
    }

    init(nodes: [MuNode] = [],
         treeVm: MuTreeVm,
         branchPrev: MuBranchVm? = nil,
         nodeType: MuNodeType = .node,
         prevNodeVm: MuNodeVm? = nil,
         level: CGFloat = 0) {

        self.nodeVms = []
        self.treeVm = treeVm
        self.level = level

        self.panelVm = MuPanelVm(nodeType: nodeType,
                                 count: nodes.count,
                                 treeVm: treeVm)
        buildNodeVms(from: nodes,
                     nodeType: nodeType,
                     prevNodeVm: prevNodeVm)

        updateTree(treeVm)
    }

    private func buildNodeVms(from nodes: [MuNode],
                              nodeType: MuNodeType,
                              prevNodeVm: MuNodeVm?) {

        for node in nodes {
            let nodeVm = MuNodeVm.cached(nodeType, node, self, prevNodeVm)
            nodeVms.append(nodeVm)
            if nodeVm.nodeType.isLeaf {
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
            leafVm.branchVm.shiftBranch()
        }
        else if let leafType = nodeSpotVm.node.leafType() {
            
            let leafNode = MuNode(name: "✎"+nodeSpotVm.node.name,
                                  parent: nodeSpotVm.node)
            
            let _ = MuBranchVm
                .cached(nodes: [leafNode],
                        treeVm: treeVm,
                        branchPrev: self,
                        nodeType: leafType,
                        prevNodeVm: nodeSpotVm,
                        level: level + 1)
        }
        else if nodeSpotVm.node.children.count > 0 {
            
            let newBranchVm = MuBranchVm
                .cached(nodes: nodeSpotVm.node.children,
                        treeVm: treeVm,
                        branchPrev: self,
                        nodeType: .node,
                        prevNodeVm: nodeSpotVm,
                        level: level+1)
            newBranchVm.expandBranch()

        }
    }

    /** May be updated after init for root tree inside update Root
     */
    func updateTree(_ treeVm: MuTreeVm?) {
        guard let treeVm = treeVm else { return }
        self.treeVm = treeVm
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
            let distance = nodeVm.center.distance(touchNow)
            // log("D",[distance], terminator: " ")
            if distance < Layout.diameter {
                nodeSpotVm?.spotlight = false
                nodeSpotVm = nodeVm
                nodeSpotVm?.spotlight = true
                nodeVm.superSpotlight()
                return nodeVm
            }
        }
        return nil
    }
    
    /** check touch point is inside a leaf's branch

        - note: already checked inclide a leaf's runway
        so expand check to inlude the title area
     */
    func findNearestLeaf(_ touchNow: CGPoint) -> MuLeafVm? {

        // is hovering over same node as before
        if let leafVm = nodeSpotVm as? MuLeafVm,
           leafVm.branchVm.boundsNow.contains(touchNow) {
            return leafVm
        }
        for nodeVm in nodeVms {
            if let leafVm = nodeVm as? MuLeafVm,
               leafVm.branchVm.boundsNow.contains(touchNow) {
                nodeSpotVm = leafVm
                nodeSpotVm?.spotlight = true
                leafVm.superSpotlight()
                return leafVm
            }
        }
        return nil
    }

    func updateBounds(_ from: CGRect) {
        if boundsNow != from {
            boundsNow = panelVm.updateBounds(from)
            boundsPad = boundsNow.pad(Layout.padding)
        }
        if boundStart == .zero {
            updateShiftRange()
        }
    }
    private var boundStart: CGRect = .zero
    var branchShift: CGSize = .zero
    var branchOpacity: CGFloat = 1
    private var shiftRange: RangeXY = (0...1, 0...1)

    func updateShiftRange() {
        guard let touchVm = treeVm.rootVm?.touchVm else { return }

        boundStart = boundsNow - CGPoint(treeVm.treeShifting)

        let rxy = touchVm.rootIconXY
        let rx = rxy.x - Layout.radius
        let ry = rxy.y - Layout.radius
        let rw = Layout.diameter
        let rh = Layout.diameter

        let bx = boundStart.origin.x
        let by = boundStart.origin.y
        let bw = boundStart.size.width
        let bh = boundStart.size.height

        shiftRange = (treeVm.axis == .vertical
                      ? (treeVm.corner.contains(.left)
                         ? (min(0, rx-bx)...0, 0...0)
                         : (0...max(0, rx-bx + rw-bw), 0...0))
                      : (treeVm.corner.contains(.upper)
                         ? (0...0, min(0,ry-by)...0)
                         : (0...0, 0...max(0, ry-by + rh-bh))))
    }

    func shiftBranch() {

        let treeShifting = treeVm.treeShifting
        if boundsNow == .zero { return }
        if boundStart == .zero { updateShiftRange() }
        branchShift = treeShifting.clamped(to: shiftRange)
        let clampDelta = branchShift-treeShifting

        if nodeVms.first?.nodeType.isLeaf ?? false {
            branchOpacity = 1 // always show leaves
        } else {
            let ww = abs(clampDelta.width) / boundStart.width
            let hh = abs(clampDelta.height) / boundStart.height
            branchOpacity = min(1-ww,1-hh)
        }

        log(title.pad(17), [shiftRange], length: 32)
        log("branch", [boundsNow], length: 25)
        //log("level", [level], terminator: " ")
        log("branchShift", [branchShift], length: 22)
        log("clampDelta", [clampDelta], length: 21)
        log("opacity",format: "%.2f", [branchOpacity])
    }
    
}

var BranchCache = [Int: MuBranchVm]()

extension MuBranchVm {
    
    static func cached(nodes: [MuNode] = [],
                       treeVm: MuTreeVm,
                       branchPrev: MuBranchVm? = nil,
                       nodeType: MuNodeType = .node,
                       prevNodeVm: MuNodeVm? = nil,
                       level: CGFloat = 0) -> MuBranchVm {

        /// predict hash of next Branch
        var nextHash: Int {
            var hasher = Hasher()
            hasher.combine(prevNodeVm?.hashValue ?? 0)
            hasher.combine(treeVm.corner.rawValue)
            hasher.combine(nodeType.icon)
            let hash = hasher.finalize()
            return hash
        }

        //let nextHash = nextHash()
        if let oldBranch = BranchCache[nextHash] {
            // print("🧺", terminator: " ")
            return oldBranch
        }
        let newBranch = MuBranchVm(
            nodes: nodes,
            treeVm: treeVm,
            branchPrev: branchPrev,
            nodeType: nodeType,
            prevNodeVm: prevNodeVm,
            level: level)

        BranchCache[nextHash] = newBranch

        return newBranch
    }
}


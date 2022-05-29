// Created by warren 10/27/21.
import SwiftUI

class MuTreeVm: Identifiable, ObservableObject {
    let id = MuIdentity.getId()

    @Published var branches: [MuBranchVm]

    var axis: Axis  // vertical or horizontal
    var level = CGFloat(1) // starting level for branches
    var offset = CGSize(width: 0, height: 0)
    var depthShown = 0 // levels of branches shown
    var nodeNowVm: MuNodeVm? // current node under pilot's dragNode

    init(branches: [MuBranchVm],
         axis: Axis,
         root: MuRootVm) {

        self.branches = branches
        self.axis = axis
        for branch in branches {
            branch.updateTree(self)
        }
        showBranches(depth: 1)
    }
    func addBranch(_ branchVm: MuBranchVm?) {
        guard let branchVm = branchVm else { return }
        branches.append(branchVm)
    }
    
    /// find nearest node to touch point
    func nearestNode(_ touchNow: CGPoint,
                     _ touchBranch: MuBranchVm?) -> MuNodeVm? {
        var skipPreBranches = (touchBranch?.treeVm?.id == id)

        for branch in branches {
            
            if branch.show == false { continue } 
            if skipPreBranches && (touchBranch?.id != branch.id) { continue }

            skipPreBranches = false

            if let nodeNext = branch.findNearestNode(touchNow) {
                if nodeNowVm?.id != nodeNext.id {
                    nodeNowVm = nodeNext
                    nodeNowVm?.superSelect()
                    refreshBranches(nodeNext)
                }
                return nodeNowVm
            }
        }
        return nil
    }

    /// evenly space brqnches leading up to spotBranch's position
    func refreshBranches(_ nodeNextVm: MuNodeVm) {

        let branchNextVm = nodeNextVm.branchVm
        // tapped on spotlight
        if let branchNext = branchNextVm.nodeNowVm?.branchVm,
           branchNext.show == true, // branchNext is also shown (tree.depth > 1)
           let subId = branchNext.nodeNowVm?.node.id,
           let nowId = nodeNextVm.node.childNow?.id, subId == nowId {
            // all subBranches are the same
            return
        }
        branchNextVm.nodeNowVm = nodeNextVm
        // remove old sub branches 
        while branches.last?.id != branchNextVm.id {
            branches.removeLast()
        }
        var newBranches = [MuBranchVm]()
        expandBranches(nodeNextVm, branches.last,  &newBranches, level + 1)
        if newBranches.count > 0 {
            branches.append(contentsOf: newBranches)
            // unfold branches
            var lag = TimeInterval(0)
            for branch in branches {
                Delay(lag) { branch.show = true }
                lag += Layout.lagStep
            }
        }
    }

    /// add a branch to selected node and follow selected kid
    func expandBranches(_ nodeNowVm: MuNodeVm?,
                        _ branchPrevVm: MuBranchVm?,
                        _ newBranchVms: inout [MuBranchVm],
                        _ level: CGFloat) {
        
        guard let nodeNowVm = nodeNowVm else { return }
        self.level = level
        nodeNowVm.spotlight = true
        
        if nodeNowVm.node.children.count > 0 {
            let newBranch = MuBranchVm(branchPrevVm: branchPrevVm,
                                       nodes: nodeNowVm.node.children,
                                       nodeNowVm: nodeNowVm,
                                       treeVm: self,
                                       show: false)
            
            newBranchVms.append(newBranch)
            if let childNow = nodeNowVm.node.childNow {
                leafBranch(childNow)
            } else if nodeNowVm.node.children.count == 1,
                      let spotChild = nodeNowVm.node.children.first {
                leafBranch(spotChild)
            }
            func leafBranch(_ leafModel: MuNode) {
                // TODO: use ordered dictionary?
                let filter = newBranch.nodeVms.filter { $0.node.id == leafModel.id }
                newBranch.nodeNowVm = filter.first
                expandBranches(newBranch.nodeNowVm, newBranch, &newBranchVms, level + 1)
                newBranch.panelVm.type = newBranch.nodeNowVm?.panelVm.type ?? .node
            }
        }
    }

    func showBranches(depth depthNext: Int) {

        var lag = TimeInterval(0)
        var newBranches = [MuBranchVm]()

        logStart() //?? 
        if      depthShown < depthNext { expandBranches() }
        else if depthShown > depthNext { contractBranches() }
        logFinish() //??

        func expandBranches() {
            var countUp = 0
            for branch in branches {
                if countUp < depthNext {
                    newBranches.append(branch)
                    Delay(lag) { branch.show = true }
                    lag += Layout.lagStep
                } else {
                    branch.show = false
                }
                countUp += 1
            }
            depthShown = min(countUp, depthNext)
        }
        func contractBranches() {
            var countDown = branches.count
            for branch in branches.reversed() {
                if countDown > depthNext,
                   branch.show == true {
                    Delay(lag) { branch.show = false }
                    lag += Layout.lagStep
                }
                countDown -= 1
            }
            depthShown = depthNext
        }
        func logStart() {
            let isRoot = branches.first?.isRoot == true
            let vert = (axis == .vertical)
            let axStr = isRoot ? " ⃝" : vert ? "V⃝" : "H⃝"
            print ("\(axStr) \(depthShown)⇨\(depthNext)", terminator: "=")
        }
        func logFinish() {
            print (depthShown, terminator: " ")
        }
    }

}

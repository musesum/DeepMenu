// Created by warren 10/27/21.
import SwiftUI

class MuLimbVm: Identifiable, ObservableObject {
    let id = MuIdentity.getId()

    @Published var branches: [MuBranchVm]
    var root: MuRootVm? // control tower root
    var axis: Axis  // vertical or horizontal
    var level = CGFloat(1) // starting level for branches
    var offset = CGSize(width: 0, height: 0)
    var depthShown = 0 // levels of branches shown
    var spotNode: MuNodeVm? // current node under pilot's flyNode

    init(branches: [MuBranchVm],
         root: MuRootVm) {

        self.branches = branches
        self.root = root
        self.axis = branches.first?.border.axis ?? .horizontal
        for branch in branches {
            branch.updateLimb(self)
        }
        showBranches(depth: 1)
    }

    /// find nearest node to touch point
    func nearestNode(_ touchNow: CGPoint,
                    _ touchBranch: MuBranchVm?) -> MuNodeVm? {
        var skipPreBranches = touchBranch?.limb?.id == id

        for branch in branches {
            
            if branch.show == false { continue } 
            if skipPreBranches && (touchBranch?.id != branch.id) { continue }

            skipPreBranches = false

            if let nextNode = branch.findHover(touchNow) {
                if spotNode?.id != nextNode.id {
                    spotNode = nextNode
                    spotNode?.superSelect()
                    refreshBranches(nextNode.branch, nextNode)
                }
                return spotNode
            }
        }
        return nil
    }

    /// evenly space docs leading up to spotBranch's position
    func refreshBranches(_ spotBranch: MuBranchVm,
                         _ spotNode: MuNodeVm) {

        // tapped on spotlight
        if let branchNext = spotBranch.branchNext,
           branchNext.show == true, // branchNext is also shown (limb.depth > 1)
           let subId = branchNext.spotNode?.node.id,
           let nowId = spotNode.node.childNow?.id, subId == nowId {
            // all subBranches are the same
            return
        }
        spotBranch.spotNode = spotNode
        // remove old sub branches 
        while branches.last?.id != spotBranch.id {
            branches.removeLast()
        }
        var newBranches = [MuBranchVm]()
        expandBranches(spotNode, branches.last,  &newBranches, level + 1)
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
    func expandBranches(_ spotNode: MuNodeVm?,
                        _ branchPrev: MuBranchVm?,
                        _ newBranches: inout [MuBranchVm],
                        _ level: CGFloat) {
        
        guard let spotNode = spotNode else { return }
        self.level = level
        spotNode.spotlight = true
        
        if spotNode.node.children.count > 0 {
            let newBranch = MuBranchVm(branchPrev: branchPrev,
                                     spotPrev: spotNode,
                                     children: spotNode.node.children,
                                     limb: self,
                                     level: level + 1,
                                     show: false,
                                     axis: axis)
            
            newBranches.append(newBranch)
            if let leafModel = spotNode.node.childNow {
                leafBranch(leafModel)
            } else if spotNode.node.children.count == 1,
                      let spotChild = spotNode.node.children.first {
                leafBranch(spotChild)
            }
            func leafBranch(_ leafModel: MuNode) {
                // TODO: use ordered dictionary?
                let filter = newBranch.branchNodes.filter { $0.node.id == leafModel.id }
                newBranch.spotNode = filter.first
                expandBranches(newBranch.spotNode, newBranch, &newBranches, level + 1)
                newBranch.border.type = newBranch.spotNode?.border.type ?? .node
            }
        }
    }

    func showBranches(depth depthNext: Int) {

        var lag = TimeInterval(0)
        var newBranches = [MuBranchVm]()

        // logStart()
        if      depthShown < depthNext { expandBranches() }
        else if depthShown > depthNext { contractBranches() }
        // logFinish()

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

// Created by warren 10/27/21.
import SwiftUI

class MuTreeVm: Identifiable, Equatable, ObservableObject {
    let id = MuIdentity.getId()
    static func == (lhs: MuTreeVm, rhs: MuTreeVm) -> Bool { return lhs.id == rhs.id }

    @Published var branchVms = [MuBranchVm]()

    var axis: Axis  // vertical or horizontal
    var level = CGFloat(1) // starting level for branches
    var offset = CGSize(width: 0, height: 0)
    var depthShown = 0 // levels of branches shown

    init(axis: Axis) {
        self.axis = axis
    }

    func addBranchVms(_ branchVms: [MuBranchVm]) {
        self.branchVms.append(contentsOf: branchVms)
        for branchVm in branchVms {
            branchVm.updateTree(self)
        }
        showBranches(depth: 1)
    }
    /** find nearest brach containing touch point
    - Parameters:
      - touchNow: current touch point

     User may either
        1) start from root and drag to hover over all branchs, or
        2) start from one of the branches and hover only outward.

     When starting from a branch, dragging towards super-branches
     will result the sub-branches to shift over. So, starting
     on a branch can only explore sub-branches. To explore all
     branches, start from the root (method 1)

     Why: allow for a bit more forgiveness when waundering slightly
     outside the branch. Often you want to explore each node within
     a single branch. That's why you jumped to that branch in the
     first place. So, allow a wider touch area to stay within
     that branch.
     */

    func nearestBranch(_ touchNow: CGPoint) -> MuBranchVm? {

        for branchVm in branchVms {
            if branchVm.show == true,
                branchVm.bounds.contains(touchNow) {
                return branchVm
            }
        }
        return nil
    }

    func refreshTree(_ branchVm: MuBranchVm) {

        var delim = " " // for logName
        func logName(_ name: String? = nil) {
            if let name = name {
                print(delim + name, terminator: "")
                delim = "."
            } else {
                print(" ", terminator: "")
            }
        }
        // begin ---------------------------
        var branchVm = branchVms.first
        var newBranches = [MuBranchVm]()
        while branchVm != nil {
            if let b = branchVm {
                b.show = true
                logName(b.nodeSpotVm?.node.name)
                newBranches.append(b)
                branchVm = b.nodeSpotVm?.nextBranchVm
            }
        }
        logName()
        branchVms = newBranches
    }

    func showBranches(depth depthNext: Int) {

        var lag = TimeInterval(0)
        var newBranches = [MuBranchVm]()

        logStart()
        if      depthShown < depthNext { expandBranches() }
        else if depthShown > depthNext { contractBranches() }
        logFinish()

        func expandBranches() {
            var countUp = 0
            for branch in branchVms {
                if countUp < depthNext {
                    newBranches.append(branch)
                    Schedule(lag) { branch.show = true }
                    lag += Layout.lagStep
                } else {
                    branch.show = false
                }
                countUp += 1
            }
            depthShown = min(countUp, depthNext)
        }
        func contractBranches() {
            var countDown = branchVms.count
            for branch in branchVms.reversed() {
                if countDown > depthNext,
                   branch.show == true {
                    Schedule(lag) { branch.show = false }
                    lag += Layout.lagStep
                }
                countDown -= 1
            }
            depthShown = depthNext
        }
        func logStart() {
            let isRoot = branchVms.first?.isRoot == true
            let vert = (axis == .vertical)
            let symbol = isRoot ? "√⃝" : vert ? "V⃝" : "H⃝"
            print ("\(symbol) \(depthShown)⇨\(depthNext)", terminator: "=")
        }
        func logFinish() {
            print (depthShown, terminator: " ")
        }
    }

}

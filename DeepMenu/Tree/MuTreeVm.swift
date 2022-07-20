// Created by warren 10/27/21.
import SwiftUI

class MuTreeVm: Identifiable, Equatable, ObservableObject {
    let id = MuIdentity.getId()
    static func == (lhs: MuTreeVm, rhs: MuTreeVm) -> Bool { return lhs.id == rhs.id }

    @Published var branchVms = [MuBranchVm]()
    @Published var treeShifting = CGSize.zero /// offset after shifting (by dragging leaf)
    var treeShifted = CGSize.zero

    var rootVm: MuRootVm?
    var branchSpotVm: MuBranchVm?
    var axis: Axis
    var corner: MuCorner

    var treeOffset = CGSize.zero

    private var level = CGFloat(1) // starting level for branches
    private var depthShown = 0 // levels of branches shown

    init(axis: Axis, corner: MuCorner) {
        self.axis = axis
        self.corner = corner
    }

    func addBranchVms(_ branchVms: [MuBranchVm]) {
        self.branchVms.append(contentsOf: branchVms)
        for branchVm in branchVms {
            branchVm.updateTree(self)
        }
        showBranches(depth: 1)
    }

    func nearestTrunk(_ touchNow: CGPoint) -> MuBranchVm? {
        if let firstBranch = branchVms.first,
           firstBranch.show {

            firstBranch.boundsPad.contains(touchNow)
            return firstBranch
        }
        return nil
    }
    func nearestBranch(_ touchNow: CGPoint) -> MuBranchVm? {

        let opacityThreshold = 0.6

        if let branchSpot = branchSpotVm,
           branchSpot.boundsPad.contains(touchNow),
           branchSpot.branchOpacity > opacityThreshold,
           branchSpot.show {

            return branchSpot
        }

        for branchVm in branchVms {
            if branchVm.show == true,
               branchVm.branchOpacity > opacityThreshold,
                branchVm.boundsPad.contains(touchNow) {
                branchSpotVm = branchVm
                return branchVm
            }
        }
        branchSpotVm = nil
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
                //?? logName(b.nodeSpotVm?.node.name)
                newBranches.append(b)
                branchVm = b.nodeSpotVm?.nextBranchVm
            }
        }
        logName()
        branchVms = newBranches
    }

    func showBranches(depth depthNext: Int) {

        var newBranches = [MuBranchVm]()

        // logStart()
        if      depthShown < depthNext { expandBranches() }
        else if depthShown > depthNext { contractBranches() }
        // logFinish()

        func expandBranches() {
            var countUp = 0
            for branch in branchVms {
                if countUp < depthNext {
                    newBranches.append(branch)
                    branch.show = true
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
                    branch.show = false
                }
                countDown -= 1
            }
            depthShown = depthNext
        }
        func logStart() {
            let symbol = (axis == .vertical) ? "V⃝" : "H⃝"
            print ("\(symbol) \(depthShown)⇨\(depthNext)", terminator: "=")
        }
        func logFinish() {
            print (depthShown, terminator: " ")
        }
    }

    func shiftTree(_ rootVm: MuRootVm,
                   _ touchState: MuTouchState) {

        if touchState.phase == .ended {
            if touchState.tapCount > 0 {
                treeShifting = .zero
                treeShifted = .zero
            } else {
                treeShifted = treeShifting
            }
            return
        }

        treeShifting = shiftConstrained()

        log("\ntreeShifting", [treeShifting, "root", rootVm.touchVm.rootIconXY])
        for branchVm in branchVms {
            branchVm.shiftBranch() 
        }

        /// constrain shifting only towards root's corner
        func shiftConstrained() -> CGSize {
            let beginΔ = touchState.pointBeginΔ
            let beginLimit =  (axis == .vertical
                               ? CGSize(width:  beginΔ.x, height: 0)
                               : CGSize(width: 0, height: beginΔ.y) )

            var constrain = treeShifted + beginLimit

            if axis == .vertical {
                constrain.width =  (corner.contains(.left)
                                     ? min(0, constrain.width)
                                     : max(0, constrain.width))
            } else { // .horizontal
                constrain.height = (corner.contains(.upper)
                                     ? min(0, constrain.height)
                                     : max(0, constrain.height))
            }
            return constrain
        }
    }
}

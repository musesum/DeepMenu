
//  MuRootVm.swift
// Created by warren 10/13/21.

import SwiftUI

class MuRootVm: ObservableObject, Equatable {
    let id = MuIdentity.getId()
    static func == (lhs: MuRootVm, rhs: MuRootVm) -> Bool { return lhs.id == rhs.id }

    @Published var status = MuRootStatus.root
    func publishStatusChanges(_ status: MuRootStatus, debug: String) {
        if self.status != status {
            self.status = status
            print(status.icon + debug, terminator: " ")
        }
    }

    var corner: MuCorner
    let touchVm = MuTouchVm()       /// captures touch events to dispatch to this root
    var treeVms = [MuTreeVm]()      /// vertical or horizontal stack of branches
    var treeSpotVm: MuTreeVm?       /// most recently used tree
    var branchSpotVm: MuBranchVm?   /// branch that is capturing touch events
    var nodeSpotVm: MuNodeVm?       /// current spotlight node
    var touch = MuTouchState()      /// begin,moved,end state plus tap count

    init(_ corner: MuCorner, axii: [Axis]) {
        
        self.corner = corner
        for axis in axii {
            let treeVm = MuTreeVm(branches: [], axis: axis, root: self)
            treeVms.append(treeVm)
            treeSpotVm = treeVm
        }
        touchVm.setRoot(self)
        updateOffsets()
    }

    /**
     Adjust tree offsets iPhone and iPad to avoid false positives, now that springboard adds a corner hotspot for launching the notes app. Also, adjust pilot offsets for home root and for flying.

     The fly ring is bigger than the home ring, so the offsets are different. To test alignment, comment out the `.opacity(...)` statements in MuBranchView. The fly ring should come to home after dragDone and encircle the home ring.
     */
    func updateOffsets() {

        let idiom = UIDevice.current.userInterfaceIdiom
        let margin = 2 * Layout.spacing
        let x = (idiom == .pad ? margin : 0)
        let y = ( (corner.contains(.upper) && idiom == .phone) ||
                  (corner.contains(.lower) && idiom == .pad)) ? margin : 0
        let xx = x + Layout.diameter + margin
        let yy = y + Layout.diameter + margin

        var vOfs = CGSize.zero // vertical offset
        var hOfs = CGSize.zero // horizontal offset
        func vert(_ w: CGFloat, _ h: CGFloat) { vOfs = CGSize(width: w, height: h) }
        func hori(_ w: CGFloat, _ h: CGFloat) { hOfs = CGSize(width: w, height: h) }

        switch corner {
            case [.lower, .right]: vert(-x,-yy); hori(-xx,-y)
            case [.lower, .left ]: vert( x,-yy); hori( xx,-y)
            case [.upper, .right]: vert(-x, yy); hori(-xx, y)
            case [.upper, .left ]: vert( x, yy); hori( xx, y)
            default: break
        }

        for treeVm in treeVms {
            treeVm.offset = (treeVm.axis == .horizontal ? hOfs : vOfs)
        }
    }

    func cornerXY(in frame: CGRect) -> CGPoint {

        let idiom = UIDevice.current.userInterfaceIdiom
        let margin = 2 * Layout.spacing
        let x = (idiom == .pad ? margin : 0)
        let y = ((corner.contains(.upper) && idiom == .phone) ||
                  (corner.contains(.lower) && idiom == .pad))  ? margin : 0
        let w = frame.size.width
        let h = frame.size.height
        let s = Layout.spacing
        let r = Layout.diameter / 2

        switch corner {
            case [.lower, .right]: return CGPoint(x: w - x - r - s, y: h - y - r - s)
            case [.lower, .left ]: return CGPoint(x:     x + r + s, y: h - y - r - s)
            case [.upper, .right]: return CGPoint(x: w - x - r - s, y:     y + r + s)
            case [.upper, .left ]: return CGPoint(x:     x + r + s, y:     y + r + s)
            default: return .zero
        }
    }

    var anchorShift = CGSize.zero
    var lastLog = "" // compare to avoid duplicate log statements

    var beginDepths: ClosedRange<Int> {
        var maxDepth = 0
        var minDepth = 99 // instead of Int.max for readable logs
        for treeVm in treeVms {
            let depth = treeVm.depthShown
            maxDepth = max(maxDepth,depth)
            minDepth = min(minDepth,depth)
        }
        return minDepth...maxDepth
    }

    ///
    var touchBranchDepth: CGFloat {
        guard let branchSpotVm = branchSpotVm else { return  0 }
        let branches = branchSpotVm.treeVm?.branchVms ?? [branchSpotVm]
        var touchBranchDepth = CGFloat(0)
        for branchi in branches {
            if  branchSpotVm.id == branchi.id { break }
            touchBranchDepth += 1
        }
        return touchBranchDepth
    }

    /// touch began at first encountered branch
    func begin(_ branchVm: MuBranchVm?,
               _ touchNow: CGPoint) {

        touch.begin(touchNow)

        guard let branchVm = branchVm else {
            // touching root
            publishStatusChanges(.root, debug: "👆₀")
            toggleBranches(lowestDepth: 1) //TODO: -- fix by determining current state
            return
        }
        self.branchSpotVm = branchVm

        // depth of branch
        anchorShift = branchVm.branchShift
        anchorBranch()
        updateRoot()
    }

    // touch began at first encountered branch
    func moved(_ touchNow: CGPoint) {

        touch.moved(touchNow)
        anchorBranch()
        updateRoot()
    }

    func ended(_ touchNow: CGPoint) {

        touch.ended(touchNow)

        if touch.tapCount > 0 {
            if let nearestNodeVm = treeSpotVm?.nearestNode(touchNow, branchSpotVm) {
                nearestNodeVm.branchVm.beginTap(nearestNodeVm)
            } else {
                toggleBranches(lowestDepth: 0)
            }
            resetRootTimer(delay: 8)
        }
        publishStatusChanges(.root, debug: "👍ₙ")
        
        if let nodeTr3 = nodeSpotVm?.node as? MuNodeTr3 {
            nodeTr3.callback(nodeTr3)
        }

        branchSpotVm = nil
    }

    /// adjust branch panels to accomadate tucking in
    private func updateBranchShift(_ branchOffset: CGSize) {
        guard let branchSpotVm = branchSpotVm else { return }

        // update each branch's `branchShift` offset
        let branches = branchSpotVm.treeVm?.branchVms ?? [branchSpotVm]
        var branchIndex = CGFloat(0)
        for branch in branches {
            let factor = (branchIndex < touchBranchDepth
                          ? branchIndex/touchBranchDepth
                          : 1)
            branch.branchShift = branchOffset * factor
            branchIndex += 1
        }
    }


    /// set fixed point for stretching/folding branchesx1x11
    func anchorBranch() {
        guard let branchSpotVm = branchSpotVm else { return }

        let deltaTouch = CGSize(touch.pointDelta)
        let (rangeW, rangeH) = getBranchRanges(branchSpotVm)
        let branchOffset = (deltaTouch + anchorShift).clamp(rangeW, rangeH)
        logTouch()
        updateBranchShift(branchOffset)

        func logTouch() {
            let touchBegin = touch.pointDelta == .zero
            if touchBegin {
                let nameFirst = branchSpotVm.nodeVms.first?.node.name ?? ""
                let nameLast  = branchSpotVm.nodeVms.last?.node.name ?? ""
                let title = nameFirst + "…" + nameLast
                log(title, [branchOffset.string()], terminator: " ")
                // let touchDelta  = touch.pointDelta.string()
                // let anchorShift = anchorShift.string()
                // let branchOffset = branchOffset.string() // clamped
                // let clamp = "\(rangeW.string()) \(rangeH.string())"
                // log(title, [touchDelta, anchorShift, branchOffset, clamp], terminator: " ")
            }
        }
        func getBranchRanges(_ branch: MuBranchVm) -> (ClosedRange<CGFloat>,
                                                       ClosedRange<CGFloat>) {
            // calc values
            let oneSpace = Layout.diameter + Layout.spacing * 3 // distance between branches
            let maxSpace = touchBranchDepth * oneSpace // maximum distance up to branch
            let vert = branch.panelVm.axis == .vertical
            let hori = branch.panelVm.axis == .horizontal
            let left = corner.contains(.left)
            let upper = corner.contains(.upper)

            let rangeW = (vert ? left
                          ? -maxSpace...0   // vertical left
                          : 0...maxSpace    // vertical right
                          : 0...0)          // hoizontal or root

            let rangeH = (hori ? upper
                          ? -maxSpace...0   // horizontal upper
                          : 0...maxSpace    // horizontal lower
                          : 0...0)          // vertical or root

            return (rangeW, rangeH)
        }
    }

    /// save time with going from depth 0 to depth 1
    var toggleDepth01Time = TimeInterval(0)

    func toggleBranches(lowestDepth: Int) {
        // going from depth 0 -> 1
        if lowestDepth == 1, beginDepths == 0...0 {
            toggleDepth01Time = Date().timeIntervalSince1970
        }
        // skip going from 1 -> 0  if recently went from 0 -> 1
        else if lowestDepth == 0 {
            let deltaTime = Date().timeIntervalSince1970 - toggleDepth01Time
            // already expanded from 0 to 1 at beginning of tap
            if deltaTime < MuTouchState.tapThreshold {
                return
            }
        }

        let depth = (beginDepths == 1...1 ? lowestDepth : 1)
        for treeVm in treeVms {
            treeVm.showBranches(depth: depth)
        }
        //??? treeNowVm = nil
    }

    /// [begin | moved] >> updateRoot
    func updateRoot() {

        resetRootTimer()

        if isExploring() {
            if let nodeVm = followTouch(touch.pointNow)  {
                nodeSpotVm = nodeVm
            }
            nodeSpotVm?.superVm?.superSpotlight()
        }
        alignSpotWithTouch(touch.pointNow)
    }

    private func followTouch(_ touchNow: CGPoint) -> MuNodeVm? {

        // check current set of menus
        if let treeNowVm = treeSpotVm,
           let nearestNode = treeNowVm.nearestNode(touchNow, branchSpotVm) {

                publishStatusChanges(.tree, debug: "👆₁")
                return nearestNode
        } else {
            // check other set of menus
            for treeVm in treeVms {
                if treeVm != treeSpotVm,
                    let nearestNode = treeVm.nearestNode(touchNow, branchSpotVm)  {

                    treeSpotVm?.showBranches(depth: 0)   // retract old tree
                    treeSpotVm = treeVm                  // set new tree
                    treeSpotVm?.showBranches(depth: 999) // expand new tree
                    publishStatusChanges(.tree, debug: "👆₂")
                    return nearestNode
                }
            }
        }
        // hovering over root
        let touchDelta = touchVm.pointHome.distance(touchNow)
        if  touchDelta < Layout.insideNode {
            if status != .root {
                publishStatusChanges(.root, debug: "👆₃")
                toggleBranches(lowestDepth: 1)
            } else {
                publishStatusChanges(.root, debug: "👆₄")
            }
            alignSpotWithTouch(touchNow)
        }
        else {
            publishStatusChanges(.space, debug: "👆₅")
            nodeSpotVm = nil
        }
        return nil
    }

    /// either center flight icon on spotNode or track finger
    private func alignSpotWithTouch(_ touchNow: CGPoint) {

        guard let nodeSpotVm = nodeSpotVm else {
            touchVm.updatePointNow(touchNow)
            return
        }
        if nodeSpotVm.type.isLeaf {
            touchVm.pointNow = touchVm.pointHome // no fly icon for leaf
            touchVm.updateDelta(.zero)
        } else {
            let delta = nodeSpotVm.center - touchNow
            touchVm.updateDelta(delta)
        }
    }

    /// cursor has not wandered past current spotlight node?
    func isExploring() -> Bool {

        guard let nodeSpotVm   = nodeSpotVm   else { return true }
        guard let touchBranch = branchSpotVm else { return true }
        let pointNow = touch.pointNow
        let pointDelta = touch.pointDelta

        // still on same spotlight node
        let spotDistance = nodeSpotVm.center.distance(pointNow)
        if spotDistance < Layout.insideNode { return false }

        // on different node inside same branch
        if touchBranch.bounds.contains(pointNow) { return true }

        // touch began at root
        if touchBranch.isRoot == true { return true }

        switch touchBranch.panelVm.axis  { // explore outward (✶) or hover inward (⌂)
            case .vertical:
                return (corner.contains(.right)
                        ? pointDelta.x < 0
                        : pointDelta.x > 0)

            case .horizontal:
                return (corner.contains(.lower)
                        ? pointDelta.y < 0
                        : pointDelta.y > 0)
        }
    }

    /// timer for auto-folding branches back into trees
    var rootTimer: Timer?

    /// cancel timer that auto-tucks in branches
    func resetRootTimer(delay: TimeInterval = -1) {
        #if false
        rootTimer?.invalidate()
        
        if delay < 0 { return } // started dragging, so don't finish old one

        func resetting(_ timer: Timer) {
            for treeVm in treeVms {
                treeVm.showBranches(depth: 0)
            }
            publishStatusChanges(.rootVm, debug: "👆₆")
        }
        rootTimer = Timer.scheduledTimer(withTimeInterval: delay,
                                        repeats: false,
                                        block: resetting)
        #endif
    }
}


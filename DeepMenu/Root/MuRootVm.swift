
//  MuRootVm.swift
// Created by warren 10/13/21.

import SwiftUI

class MuRootVm: ObservableObject, Equatable {
    let id = MuIdentity.getId()
    static func == (lhs: MuRootVm, rhs: MuRootVm) -> Bool { return lhs.id == rhs.id }

    var status = MuRootStatus.root {
        willSet {
            if status != newValue {
                objectWillChange.send()
                print(newValue.icon, terminator: " ")
            }
        }
    }

    func updateChanged(nodeSpotVm: MuNodeVm) {

        if self.nodeSpotVm != nodeSpotVm  {
            self.nodeSpotVm = nodeSpotVm
            nodeSpotVm.branchVm?.refreshBranch(nodeSpotVm)
        }
    }

    var corner: MuCorner            /// corner where root begins, ex: `[south,west]`
    let touchVm = MuTouchVm()       /// captures touch events to dispatch to this root
    var treeVms = [MuTreeVm]()      /// vertical or horizontal stack of branches
    var treeSpotVm: MuTreeVm?       /// most recently used tree
    var nodeSpotVm: MuNodeVm?       /// current spotlight node
    var touchState = MuTouchState() /// begin,moved,end state plus tap count

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

    /// touch began at first encountered branch
    func begin( _ touchNow: CGPoint) {

        touchState.begin(touchNow)
        updateRoot()
    }

    // touch began at first encountered branch
    func moved(_ touchNow: CGPoint) {

        touchState.moved(touchNow)
        updateRoot()
    }

    func onSameNode(_ touchNow: CGPoint) -> MuNodeVm? {
        // is hovering over same node as before
        if (nodeSpotVm?.center.distance(touchNow) ?? .infinity) < Layout.diameter {
            return nodeSpotVm
        }
        return nil
    }

    func ended(_ touchNow: CGPoint) {

        touchState.ended(touchNow)

        // tapped on something
        if touchState.tapCount > 0 {
            // search branches and node within that branch
            if let branchVm = treeSpotVm?.nearestBranch(touchNow),
               let nodeVm = branchVm.findNearestNode(touchNow) {

                branchVm.refreshBranch(nodeVm)
                updateChanged(nodeSpotVm: nodeVm)
            } else {
                toggleBranches(lowestDepth: 0)
            }
            resetRootTimer(delay: 8)
        }
        status = .root
        
        if let nodeTr3 = nodeSpotVm?.node as? MuNodeTr3 {
            nodeTr3.callback(nodeTr3)
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
    }

    /// [begin | moved] >> updateRoot
    func updateRoot() {

        resetRootTimer()
        if let nodeVm = followTouch(touchState.pointNow)  {
            nodeSpotVm = nodeVm
            nodeSpotVm?.superSpotlight()
        }
        alignSpotWithTouch(touchState.pointNow)
    }

    private func followTouch(_ touchNow: CGPoint) -> MuNodeVm? {

        // check current set of menus
        if let treeNowVm = treeSpotVm,
           let nearestBranch = treeNowVm.nearestBranch(touchNow),
           let nearestNode = nearestBranch.findNearestNode(touchNow) {

            updateChanged(nodeSpotVm: nearestNode)
            status = .tree
            return nearestNode

        } else {
            // check other set of menus
            for treeVm in treeVms {
                if treeVm != treeSpotVm,
                   let nearestBranch = treeVm.nearestBranch(touchNow),
                   let nearestNode = nearestBranch.findNearestNode(touchNow) {

                    updateChanged(nodeSpotVm: nearestNode)
                    treeSpotVm?.showBranches(depth: 0)   // retract old tree
                    treeSpotVm = treeVm                  // set new tree
                    treeSpotVm?.showBranches(depth: 999) // expand new tree
                    status = .tree
                    return nearestNode
                }
            }
        }
        // hovering over root
        let touchDelta = touchVm.pointHome.distance(touchNow)
        if  touchDelta < Layout.insideNode {
            if status != .root {
                status = .root
                toggleBranches(lowestDepth: 1)
            } else {
                status = .root
            }
            alignSpotWithTouch(touchNow)
        }
        else {
            status = .space
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
            // return dragNode to homeNode
            touchVm.pointNow = touchVm.pointHome
            touchVm.updateDelta(.zero)
        } else {
            // center dragNode to center of nodeSpot
            let delta = nodeSpotVm.center - touchNow
            touchVm.updateDelta(delta)
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
            status = .root
        }
        rootTimer = Timer.scheduledTimer(withTimeInterval: delay,
                                        repeats: false,
                                        block: resetting)
        #endif
    }
}




//  MuRoot.swift
// Created by warren 10/13/21.
import SwiftUI

class MuRoot: ObservableObject, Equatable {
    let id = MuIdentity.getId()
    static func == (lhs: MuRoot, rhs: MuRoot) -> Bool {
        return lhs.id == rhs.id
    }

    @Published var status = MuRootStatus.root
    func updateStatus(_ newValue: MuRootStatus, debug: String) {
        if status != newValue {
            status = newValue
            print(status.description + debug, terminator: " ")
        }
    }

    var corner: MuCorner
    var limbs = [MuLimb]() // usually a vertical and horizon limb
    var spotLimb: MuLimb?  // most recently used limb

    let pilot = MuPilot()   // captures touch events to dispatch to this root
    var spotNode: MuNode?     // current spotlight node
    var touchBranch: MuBranch?  // branch that is capturing touch events
    var touch: MuTouch = MuTouch()

    init(_ corner: MuCorner, branches: [MuBranch]?) {

        self.corner = corner
        pilot.setRoot(self)

        if let branches = branches {
            limbs = branches.map({ branch in
                MuLimb(branches: [branch], root: self)
            })
        }
        
        updateOffsets()
    }

    /**
     Adjust limb offsets iPhone and iPad to avoid false positives, now that springboard adds a corner hotspot for launching the notes app.
     Also, adjust pilot offsets for home root and for flying.

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

        for limb in limbs {
            limb.offset = (limb.axis == .horizontal ? hOfs : vOfs)
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

    var beginDepths: ClosedRange<Int> { get {
        var maxDepth = 0
        var minDepth = 99 // instead of Int.max for readable logs
        for limb in limbs {
            let depth = limb.depthShown
            maxDepth = max(maxDepth,depth)
            minDepth = min(minDepth,depth)
        }
        return minDepth...maxDepth
    }}

    ///
    var touchBranchDepth: CGFloat { get {
        guard let branch = touchBranch else { return  0 }
        let branches = branch.limb?.branches ?? [branch]
        var touchBranchDepth = CGFloat(0)
        for branchi in branches {
            if  branch.id == branchi.id { break }
            touchBranchDepth += 1
        }
        return touchBranchDepth
    }}
    // touch began at first encountered branch
    func begin(_ branch: MuBranch?,
               _ touchNow: CGPoint) {

        touch.begin(touchNow)

        guard let branch = branch else {
            // touching root
            updateStatus(.root, debug: "1")
            toggleBranches(lowestDepth: 1) //TODO: -- fix by determining current state
            return
        }
        self.touchBranch = branch

        // depth of branch
        anchorShift = branch.branchShift
        anchorBranch()
        updateRoot()
        spotNode?.superSelect() // bookmark route through super nodes
    }

    // touch began at first encountered branch
    func moved(_ pointNow: CGPoint) {

        touch.moved(pointNow)
        anchorBranch()
        updateRoot()
    }

    func ended(_ pointNow: CGPoint) {

        touch.ended(pointNow)

        if touch.tapCount > 0 {

            resetRootTimer(delay: 8)
            if let touchBranch = touchBranch {
                touchBranch.beginTap()
            } else {
                toggleBranches(lowestDepth: 0)
            }
        }
        updateStatus(.root, debug: "2")
        
        if let nodeModel = self.spotNode?.model {
            if nodeModel.borderType == .node {
                nodeModel.callback(nodeModel)
            } else if nodeModel.borderType == .slider {
                // TODO: this should somehow be passing updated values from a slider via nodeModel.callback(value)
            }
        }

        touchBranch = nil
    }

    func updateBranchShift(_ branchOffset: CGSize) {
        // update each branch's `branchShift` offset
        guard let branch = touchBranch else { return }
        let branches = branch.limb?.branches ?? [branch]
        var branchIndex = CGFloat(0)
        for branch in branches {
            let factor = (branchIndex < touchBranchDepth) ? branchIndex/touchBranchDepth : 1
            branch.branchShift = branchOffset * factor
            branchIndex += 1
        }
    }

    func getRanges(_ branch: MuBranch) -> (ClosedRange<CGFloat>,
                                       ClosedRange<CGFloat>) {
        // calc ranges
        let oneSpace = Layout.diameter + Layout.spacing * 3 // distance between branches
        let maxSpace = touchBranchDepth * oneSpace // maximum distance up to branch
        let vert = branch.border.axis == .vertical
        let hori = branch.border.axis == .horizontal
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

    /// set fixed point for stretching/folding branches
    func anchorBranch() {

        if let touchBranch = touchBranch {

            let deltaTouch = CGSize(touch.pointDelta)
            let (rangeW, rangeH) = getRanges(touchBranch)
            let branchOffset = (deltaTouch + anchorShift).clamp(rangeW, rangeH)

            let begin = touch.pointDelta == .zero
            if begin { logRange() }
            updateBranchShift(branchOffset)

            func logRange() {
                let touchDelta  = touch.pointDelta.string()
                let anchorShift = anchorShift.string()
                let branchOffset = branchOffset.string() // clamped
                let clamp = "\(rangeW.string()) \(rangeH.string())"

                let newLog = "\(touchBranch.title) \(touchDelta) \(anchorShift) \(branchOffset) \(clamp)"
                if lastLog != newLog {
                    lastLog = newLog
                    print(newLog, terminator: " ")
                }
            }
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
            if deltaTime < MuTouch.tapInterval {
                return
            }
        }

        let depth = (beginDepths == 1...1 ? lowestDepth : 1)
        for limb in limbs {
            limb.showBranches(depth: depth)
        }
        spotLimb = nil 
    }

    /// [begin | moved] >> updateRoot
    func updateRoot() {

        resetRootTimer()

        if isExploring() {
            if let spotNext = followTouch(touch.pointNow)  {
                spotNode = spotNext
                // print(".", terminator: "")
            }
            spotNode?.superSpotlight()
        }
        alignFlightWithSpotNode(touch.pointNow)
    }


    func followTouch(_ touchNow: CGPoint) -> MuNode? {

        func setSpotLimb(_ limbNext: MuLimb) {
            
            for hideLimb in limbs {
                if hideLimb.id != limbNext.id {
                    hideLimb.showBranches(depth: 0)
                }
                spotLimb = limbNext
                spotLimb?.showBranches(depth: 99) 
            }
            updateStatus(.limb, debug: "3")
        }

        // begin -------------------------------------------

        // have been exploring a limb already
        if let spotLimb = spotLimb {
            if let nearestNode = spotLimb.nearestNode(touchNow, touchBranch) {
                // still within same spotlight limb
                updateStatus(.limb, debug: "6")
                return nearestNode
            } else {
                // no longer on spotLimb
                for limb in limbs {
                    // skip spotlight limb
                    if limb.id == spotLimb.id { continue }
                    // look for nearestNode
                    if let nearestNode = limb.nearestNode(touchNow, touchBranch) {
                        // found a node on another limb
                        setSpotLimb(limb)
                        return nearestNode
                    }
                }
            }
        }
        // starting out from root
        else {
            for limb in limbs {
                if let nearestNode = limb.nearestNode(touchNow, touchBranch)  {
                    setSpotLimb(limb)
                    return nearestNode
                }
            }
        }
        // hovering over root
        if pilot.pointHome.distance(touchNow) < Layout.spotArea {
            if status != .root {
                updateStatus(.root, debug: "4")
                toggleBranches(lowestDepth: 1)
            } else {
                updateStatus(.root, debug: "-4")
            }
            pilot.root?.alignFlightWithSpotNode(touchNow)
        }
        else {
            updateStatus(.space, debug: "5")
        }
        return nil
    }

    /// either center flight icon on spotNode or track finger
    private func alignFlightWithSpotNode(_ touchNow: CGPoint) {

        if spotNode?.model.borderType == .rect {
            pilot.pointNow = pilot.pointHome // no fly icon for leaf
        }
        else if let spotXY = spotNode?.nodeXY {
            let pointDelta = spotXY - touchNow
            pilot.updateDelta(pointDelta)
        } else {
            pilot.updateDelta(.zero)
        }
    }

    /// cursor has not wandered past current spotlight node?
    func isExploring() -> Bool {

        guard let spotNode   = spotNode   else { return true }
        guard let touchBranch = touchBranch else { return true }
        let pointNow = touch.pointNow
        let pointDelta = touch.pointDelta

        // still on same spotlight node
        let spotDistance = abs(spotNode.nodeXY.distance(pointNow))
        if spotDistance < Layout.zone { return false }

        // on different node inside same branch
        if touchBranch.bounds.contains(pointNow) { return true }

        // touch began at root
        if touchBranch.isRoot == true { return true }

        switch touchBranch.border.axis  { // explore outward (✶) or hover inward (⌂)
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

    /// timer for auto-folding branches back into limbs
    var hubTimer: Timer?

    /// cancel timer that auto-tucks in branches
    func resetRootTimer(delay: TimeInterval = -1) {
        #if false
        hubTimer?.invalidate()
        
        if delay < 0 { return } // started dragging, so don't finish old one

        func resetting(_ timer: Timer) {
            for limb in limbs {
                limb.showBranches(depth: 0)
            }
            updateStatus(.root, debug: "9")
        }
        hubTimer = Timer.scheduledTimer(withTimeInterval: delay,
                                        repeats: false,
                                        block: resetting)
        #endif
    }
}


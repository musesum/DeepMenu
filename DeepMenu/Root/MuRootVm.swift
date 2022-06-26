
//  MuRootVm.swift
// Created by warren 10/13/21.

import SwiftUI
import Tr3

class MuRootVm: ObservableObject, Equatable {
    let id = MuIdentity.getId()
    static func == (lhs: MuRootVm, rhs: MuRootVm) -> Bool { return lhs.id == rhs.id }

    /// what is the finger touching
    @Published var touchElement = MuElement.none

    /// which elements are shown on View
    var viewElements: Set<MuElement> = [.home, .trunks] {
        willSet { if viewElements != newValue {
                log(":", [beginElements,"⟶",newValue], terminator: " ")
            } } }

    /// touchBegin snapshot of viewElements
    /// to prevent touch ended from hiding elements that
    /// were shown (revealed at beginning of touch
    var beginElements: Set<MuElement> = []

    var corner: MuCorner         /// corner where root begins, ex: `[south,west]`
    let touchVm = MuTouchVm()    /// captures touch events to dispatch to this root
    var treeVms = [MuTreeVm]()   /// vertical or horizontal stack of branches
    var treeSpotVm: MuTreeVm?    /// most recently used tree

    /// current spotlight node
    var nodeSpotVm: MuNodeVm?
                                 ///
    func updateChanged(nodeSpotVm: MuNodeVm) {
        if self.nodeSpotVm != nodeSpotVm  {
            self.nodeSpotVm = nodeSpotVm
            nodeSpotVm.refreshBranch()
            nodeSpotVm.superSpotlight()
        }
    }

    init(_ corner: MuCorner, treeVms: [MuTreeVm]) {

        self.corner = corner
        self.treeVms = treeVms
        for treeVm in treeVms {
            treeVm.rootVm = self
        }
        treeSpotVm = treeVms.first
        touchVm.setRoot(self)
        updateOffsets()
    }

    /**
     Adjust tree offsets iPhone and iPad to avoid false positives, now that springboard adds a corner hotspot for launching the notes app. Also, adjust pilot offsets for home root and for flying.

     The dragNode ring is bigger than the home ring, so the offsets are different. To test alignment, comment out the `.opacity(...)` statements in MuBranchView. The dragNode ring should come to home after dragDone and encircle the home ring.
     */
    func updateOffsets() {

        let idiom = UIDevice.current.userInterfaceIdiom
        let margin = 2 * Layout.padding
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
        let margin = 2 * Layout.padding
        let x = (idiom == .pad ? margin : 0)
        let y = ((corner.contains(.upper) && idiom == .phone) ||
                 (corner.contains(.lower) && idiom == .pad))  ? margin : 0
        let w = frame.size.width
        let h = frame.size.height
        let s = Layout.padding
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

    func touchBegin(_ touchState: MuTouchState) {
        beginElements = viewElements
        updateRoot(touchState.pointNow)
    }
    func touchMoved(_ touchState: MuTouchState) {
        updateRoot(touchState.pointNow)
    }
    func touchEnded(_ touchState: MuTouchState) {
        updateRoot(touchState.pointNow, taps: touchState.tapCount)
    }
    /// [begin | moved] >> updateRoot
    func updateRoot(_ touchNow: CGPoint, taps: Int = 0) {

        resetRootTimer()

        if        hoverNodeSpot() {
        } else if tapHomeNode() {
        } else if hoverHomeNode() {
        } else if hoverTreeNow() {
        } else if hoverTreeAlts() {

        } else {
            touchElement = .space
            nodeSpotVm = nil
        }

        func hoverNodeSpot() -> Bool {
            if let nodeSpotVm = nodeSpotVm,
               nodeSpotVm.center.distance(touchNow) < Layout.insideNode {

                touchElement = nodeSpotVm.type.isLeaf ? .leaf : .node
                return true
            }
            return false
        }

        func hoverTreeNow() -> Bool {
            // check current set of menus
            if let treeNowVm = treeSpotVm,
               let nearestBranch = treeNowVm.nearestBranch(touchNow),
               let nearestNode = nearestBranch.findNearestNode(touchNow) {

                updateChanged(nodeSpotVm: nearestNode)

                if !viewElements.contains(.branch) {
                    log("~", terminator: "")
                    viewElements = [.home,.branch]
                    touchElement = .branch
                }
                return true
            }
            return false
        }
        func hoverTreeAlts()-> Bool {
            // hovering over hidden trunk of another tree?
            for treeVm in treeVms {
                if treeVm != treeSpotVm,
                   let nearestTrunk = treeVm.nearestTrunk(touchNow),
                   let nearestNode = nearestTrunk.findNearestNode(touchNow) {
                    treeSpotVm = treeVm                  // set new tree

                    for treeVm in treeVms {
                        if treeVm == treeSpotVm {
                            treeVm.showBranches(depth: 999)
                        } else {
                            treeVm.showBranches(depth: 0)
                        }
                    }
                    updateChanged(nodeSpotVm: nearestNode)

                    log("≈", terminator: "")
                    viewElements = [.home,.branch]
                    touchElement = .branch
                    return true
                }
            }
            return false
        }
        func tapHomeNode() -> Bool {
            // hovering over root in corner?
            if taps > 0 {
                let homeIconΔ = touchVm.homeIconXY.distance(touchNow)
                if  homeIconΔ < Layout.insideNode {
                    if beginElements.intersection( [.branch,.trunks]).count > 0 {
                        hideBranches()
                    } else {
                        showBranches()
                    }
                    touchElement = .none
                    return true
                }
            }
            return false
        }
        func hoverHomeNode() -> Bool {
            // hovering over root in corner?
            let homeIconΔ = touchVm.homeIconXY.distance(touchNow)
            if  homeIconΔ < Layout.insideNode {

                if touchElement != .home {
                    touchElement = .home
                    if viewElements.intersection( [.branch,.trunks]).count > 0 {
                        showTrunks()
                    } else {
                        showBranches()
                    }
                }
                return true
            }
            return false
        }
        func showTrunks() {
            if treeVms.count == 1 {
                showSoloTree()
            } else {
                for treeVm in treeVms {
                    treeVm.showBranches(depth: 1)
                }
                treeSpotVm = nil
                log("+ᛘ", terminator: "")
                viewElements = [.home, .trunks]
            }
        }
        func showSoloTree() {
            if let treeVm = treeVms.first {
                treeSpotVm = treeVm
                treeVm.showBranches(depth: 999)
                log("+𐂷", terminator: "")
                viewElements = [.home,.branch]
            }
        }
        func showBranches() {
            if let treeSpotVm = treeSpotVm {
                for treeVm in treeVms {
                    if treeVm == treeSpotVm {
                        treeVm.showBranches(depth: 999)
                    } else {
                        treeVm.showBranches(depth: 0)
                    }
                    log("+𐂷", terminator: "")
                    viewElements = [.home,.branch]
                }
            } else {
                showTrunks()
            }
        }
        func hideBranches() {
            for treeVm in treeVms {
                treeVm.showBranches(depth: 0)
            }
            treeSpotVm = nil
            log("-𐂷", terminator: "")
            viewElements = [.home]
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
            touchElement = .home
        }
        rootTimer = Timer.scheduledTimer(withTimeInterval: delay,
                                         repeats: false,
                                         block: resetting)
#endif
    }
}

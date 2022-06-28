
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

    var corner: MuCorner        /// corner where root begins, ex: `[south,west]`
    let touchVm = MuTouchVm()   /// captures touch events to dispatch to this root
    var treeVms = [MuTreeVm]()  /// vertical or horizontal stack of branches
    var treeSpotVm: MuTreeVm?   /// most recently used tree
    var nodeSpotVm: MuNodeVm?   /// current spotlight node
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

    func touchBegin(_ touchState: MuTouchState) {
        beginElements = viewElements
        updateRoot(touchState)
    }
    func touchMoved(_ touchState: MuTouchState) {
        updateRoot(touchState)
    }
    func touchEnded(_ touchState: MuTouchState) {
        updateRoot(touchState)

        /// turn off spotlight for leaf after edit
        if let nodeSpotVm = nodeSpotVm,
           nodeSpotVm.type.isLeaf {
            nodeSpotVm.spotlight = false
        }
        treeSpotVm?.branchSpot = nil
        touchElement = .none
    }
    /// [begin | moved] >> updateRoot
    private func updateRoot(_ touchState: MuTouchState) {
        let touchNow = touchState.pointNow
        let taps = touchState.tapCount

        log(touchElement.symbol, terminator: "")
        
        if        editLeafNode() {
        } else if hoverNodeSpot() {
        } else if tapHomeNode() {
        } else if hoverHomeNode() {
        } else if hoverTreeNow() {
        } else if hoverTreeAlts() {
        } else {  hoverSpace() }

        func editLeafNode() -> Bool {

            if let leafVm = nodeSpotVm as? MuLeafVm {

                func updateLeaf() {
                    let touchDelta = touchState.pointNow -  leafVm.runwayBounds.origin
                    for leaf in leafVm.node.leaves {
                        leaf.touchLeaf(touchDelta)
                    }
                }
                if leafVm.runwayBounds.contains(touchState.pointNow) {
                    if (touchElement == .edit || touchState.phase == .begin) {
                        // begin touch inside control runway
                        touchElement = .edit
                        // leaf spotlight on if not ended
                        leafVm.spotlight = touchState.phase != .ended
                        // branch spotlight off
                        leafVm.branchVm.treeVm.branchSpot = nil
                        updateLeaf()
                    }
                    return true
                } else if leafVm.branchVm.bounds.contains(touchNow),
                          touchElement != .edit {
                    // begin touch on title section to possibly stack branches
                    touchElement = .leaf
                    // leaf spotlight off
                    leafVm.spotlight = false
                    // set spotlight on
                    leafVm.branchVm.treeVm.branchSpot = leafVm.branchVm
                    return true
                } else if touchElement == .edit  {

                    updateLeaf()
                    return true
                }
            }
            return false
        }
        func hoverNodeSpot() -> Bool {
            if let nodeSpotVm = nodeSpotVm,
               nodeSpotVm.center.distance(touchNow) < Layout.insideNode {
                    touchElement = .node
                return true
            }
            return false
        }
        func tapHomeNode() -> Bool {
            // tapping on homeNode in corner?
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
            // hovering over homeNode in corner?
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
        func hoverTreeNow() -> Bool {
            // check current set of menus
            if let treeNowVm = treeSpotVm,
               let nearestBranch = treeNowVm.nearestBranch(touchNow) {

                if let nearestNodeVm = nearestBranch.findNearestNode(touchNow) {

                    updateChanged(nodeSpotVm: nearestNodeVm)

                    if touchState.phase == .begin,
                       let leafVm = nodeSpotVm as? MuLeafVm {

                        if leafVm.contains(touchNow) {
                            // touch directly inside leaf Runway triggers edit
                            touchElement = .edit
                        }
                    } else if !viewElements.contains(.branch) {
                        log("~", terminator: "")
                        viewElements = [.home,.branch]
                        touchElement = .branch
                    }
                    return true
                } else if let nearestLeafVm = nearestBranch.findNearestLeaf(touchNow) {
                    // special case where not touching on leaf runway but is touching headline
                    if touchState.phase == .begin {
                        updateChanged(nodeSpotVm: nearestLeafVm)
                        touchElement = .leaf
                        return true
                    }
                }
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
        func hoverSpace() {
            touchElement = .space
            nodeSpotVm = nil
        }

        //  show/hide -----------

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
}

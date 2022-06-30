
//  MuRootVm.swift
// Created by warren 10/13/21.

import SwiftUI
import Tr3

class MuRootVm: ObservableObject, Equatable {
    let id = MuIdentity.getId()
    static func == (lhs: MuRootVm, rhs: MuRootVm) -> Bool { return lhs.id == rhs.id }

    /// what is the finger touching
    @Published var touchElement = MuElement.none

    /// which menu elements are shown on View
    var viewElements: Set<MuElement> = [.root, .trunks] {
        willSet { if viewElements != newValue {
                log(":", [beginElements,"⟶",newValue], terminator: " ")
            } } }

    /// touchBegin snapshot of viewElements, to prevent
    /// touchEnded hiding elements show  during touchBegin
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
        treeSpotVm = treeVms.first
        touchVm.setRoot(self)
        updateOffsets()
    }

    /**
     Adjust tree offsets iPhone and iPad to avoid false positives, now that springboard adds a corner hotspot for launching the notes app. Also, adjust pilot offsets for root and for flying.
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
            treeVm.treeOffset = (treeVm.axis == .horizontal ? hOfs : vOfs)
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

        //log(touchElement.symbol, terminator: "")
        if        editLeafNode() {
        } else if hoverNodeSpot() {
        } else if tapRootNode() {
        } else if hoverRootNode() {
        } else if hoverTreeNow() {
        } else if hoverTreeAlts() {
        } else {  hoverSpace() }
        //log(touchElement.symbol, terminator: " ")

        func editLeafNode() -> Bool {

            if let leafVm = nodeSpotVm as? MuLeafVm {

                if leafVm.runwayBounds.contains(touchState.pointNow) {
                    if (touchElement == .edit || touchState.phase == .begin) {
                        updateLeaf(leafVm)
                    }
                    return true
                } else if leafVm.branchVm.bounds.contains(touchNow),
                          touchElement != .edit {
                   stackBranches(leafVm)
                    return true
                } else if touchElement == .edit  {
                    updateLeaf(leafVm)
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
        func tapRootNode() -> Bool {
            // tapping on rootNode in corner?
            if taps > 0 {
                let rootIconΔ = touchVm.rootIconXY.distance(touchNow)
                if  rootIconΔ < Layout.insideNode {
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
        func hoverRootNode() -> Bool {
            // hovering over rootNode in corner?
            let rootIconΔ = touchVm.rootIconXY.distance(touchNow)
            if  rootIconΔ < Layout.insideNode {

                if touchElement != .root {
                    touchElement = .root
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
                            updateLeaf(leafVm)
                        }
                    } else if !viewElements.contains(.branch) {
                        log("~", terminator: "")
                        viewElements = [.root,.branch]
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
                    viewElements = [.root,.branch]
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

        //  show/hide/stack -----------

        func stackBranches(_ leafVm: MuLeafVm) {
            // begin touch on title section to possibly stack branches
            touchElement = .leaf
            // leaf spotlight off
            leafVm.spotlight = false
            // set spotlight on
            leafVm.branchVm.treeVm.branchSpot = leafVm.branchVm
            log("stack", [touchState.pointBeginΔ], terminator: " ")
            if let treeSpotVm = treeSpotVm {
                treeSpotVm.stackBranches(touchState.pointBeginΔ)
            }
        }

        func updateLeaf(_ leafVm: MuLeafVm) {

            if touchElement != .edit {
                // begin touch inside control runway
                touchElement = .edit
                // leaf spotlight on if not ended
                leafVm.spotlight = touchState.phase != .ended
                // branch spotlight off
                leafVm.branchVm.treeVm.branchSpot = nil
            }
            for proxy in leafVm.node.proxies {
                proxy.touchLeaf(touchState)
            }
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
                viewElements = [.root, .trunks]
            }
        }
        func showSoloTree() {
            if let treeVm = treeVms.first {
                treeSpotVm = treeVm
                treeVm.showBranches(depth: 999)
                log("+𐂷", terminator: "")
                viewElements = [.root,.branch]
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
                    viewElements = [.root,.branch]
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
            viewElements = [.root]
        }
    }
}

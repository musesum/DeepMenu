
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
        }
    }

    init(_ corner: MuCorner, treeVms: [MuTreeVm]) {

        self.corner = corner
        self.treeVms = treeVms
        treeSpotVm = treeVms.first
        touchVm.setRoot(self)
        updateOffsets()
        for treeVm in treeVms {
            treeVm.rootVm = self
        }
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
           nodeSpotVm.nodeType.isLeaf {
            nodeSpotVm.spotlight = false
        }
        treeSpotVm?.branchSpotVm = nil
        touchElement = .none
    }

    private func updateRoot(_ touchState: MuTouchState) {
        let touchNow = touchState.pointNow
        let taps = touchState.tapCount

        // stay exclusively on .leaf or .edit mode
        switch touchElement {
            case .shift: return shiftBranches()
            case .edit:  return editLeaf()
            case .sky:   return hoverSpace()
            default:     break
        }

        if        hoverLeafNode() { // editing leaf or shifting branch
        } else if hoverNodeSpot() { // is over the same branch node
        } else if hoverRootNode() { // is tapping or over the root (home) node
        } else if hoverTreeNow()  { // shifted to new node on same tree
        } else if hoverTreeAlts() { // shifted to space reserved for alternate tree
        } else {  hoverSpace()    } // hovering over canvas, plus future UIKit drawing
        log(touchElement.symbol, terminator: "")
        func hoverLeafNode() -> Bool {
            if touchState.phase == .begin,
               let leafVm = nodeSpotVm as? MuLeafVm {

                if leafVm.runwayBounds.contains(touchNow) {
                    // inside runway
                    editLeaf()
                    return true

                } else if leafVm.branchVm.boundsNow.contains(touchNow) {
                    // inside branch containing runway
                    shiftBranches()
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
        func hoverRootNode() -> Bool {
            let isOverRootNode = touchVm.rootIconXY.distance(touchNow) < Layout.insideNode
            if  isOverRootNode {
                if taps > 0 {
                    touchElement = .none
                    let wasShown = beginElements.hasAny([.branch,.trunks])
                    if  wasShown { hideBranches() }
                    else         { showBranches() }
                } else if touchElement != .root {
                    touchElement = .root
                    let isShowing = viewElements.hasAny([.branch,.trunks])
                    if  isShowing { showTrunks() }
                    else          { showBranches() }
                }
                return true
            }
            return false
        }
        func hoverTreeNow() -> Bool {
            // check current set of menus
            guard let treeSpotVm = treeSpotVm else { return false }
            if let nearestBranch = treeSpotVm.nearestBranch(touchNow) {

                if let nearestNodeVm = nearestBranch.findNearestNode(touchNow) {

                    updateChanged(nodeSpotVm: nearestNodeVm)
                    if hoverLeafNode() {
                        // already set touchElement
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
                        touchElement = .shift
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
            if touchElement == .sky {
                // future reference for UIKit compatibility drawing canvas
            } else {
                touchElement = (touchState.phase == .begin
                                ? .sky // UIKit canvas
                                : .space) // SwiftUI menu mode
                nodeSpotVm = nil
            }
        }

        //  show/hide/stack -----------

        func shiftBranches() {
            guard let leafVm = nodeSpotVm as? MuLeafVm else { return }
            // begin touch on title section to possibly stack branches
            touchElement = .shift
            // leaf spotlight off
            leafVm.spotlight = false
            // set spotlight on
            leafVm.branchVm.treeVm.branchSpotVm = leafVm.branchVm

            treeSpotVm?.shiftTree(self, touchState)
        }

        func editLeaf() {
            guard let leafVm = nodeSpotVm as? MuLeafVm else { return }
            if touchElement != .edit {
                // begin touch inside control runway
                touchElement = .edit
                // leaf spotlight on if not ended
                leafVm.spotlight = touchState.phase != .ended
                // branch spotlight off
                leafVm.branchVm.treeVm.branchSpotVm = nil
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

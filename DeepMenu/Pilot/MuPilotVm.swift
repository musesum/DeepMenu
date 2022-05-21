// Created by warren on 10/31/21.

import SwiftUI

/**
 Draggable clone of node withing a branch, which clips at border
 - note: Instead, move clones on space
 */
class MuPilotVm: ObservableObject {

    @Published var pointNow = CGPoint.zero    // current position
    var pointHome = CGPoint.zero  // starting position of touch
    var alpha: CGFloat { get { (pointNow == pointHome) || (pointNow == .zero) ? 1 : 0 }}

    var rootVm: MuRootVm?
    var baseNodeVm: MuNodeVm    // fixed node to start touch from
    var hoverNodeVm: MuNodeVm?  // selected hover node while dragging
    var rootBranch: MuBranchVm

    private var touchOfs = CGSize.zero // offset between rootNode and touchNow
    var deltaOfs = CGSize.zero // offset between touch point and center in coord
    var pilotOfs: CGSize { get {
        switch rootVm?.status ?? .root {
            case .root:  return touchOfs
            case .limb:  return deltaOfs
            case .space: return deltaOfs
        }}}

    /// adjust offset for root on right side of canvas
    func rightSideOffset(for rootStatus: MuRootStatus) -> CGFloat {
        if let root = rootVm,
           root.status == rootStatus,
           root.corner.contains(.right) {
            return -(2 * Layout.spacing)
        } else {
            return 0
        }
    }

    var touchBranch: MuBranchVm? // branch which captured DragGesture
    var pointDelta = CGPoint.zero // touch starting position

    init() {
        let node = MuNodeTest("⚫︎") // name changed below
        rootBranch = MuBranchVm(isRoot: true, axis: .horizontal)
        baseNodeVm = MuNodeVm(.node, rootBranch, node, icon: Layout.hoverRing)
        rootBranch.addNode(baseNodeVm)
    }
    
    func setRootVm(_ rootVm: MuRootVm) {
        self.rootVm = rootVm
        var name: String
        switch rootVm.corner {
            case [.lower, .right]: name = "◢"
            case [.lower, .left ]: name = "◣"
            case [.upper, .right]: name = "◥"
            case [.upper, .left ]: name = "◤"

                // reserved for later middling roots
            case [.upper]: name = "▲"
            case [.right]: name = "▶︎"
            case [.lower]: name = "▼"
            case [.left ]: name = "◀︎"
            default:       name = "??"
        }
        baseNodeVm.node.name = name
    }

    func setTouchNow( _ touchNow: CGPoint) {
        pointNow = touchNow
        pointDelta = touchNow
        touchOfs = CGSize(baseNodeVm.center - touchNow)
        touchOfs.width += rightSideOffset(for: .root)
        deltaOfs = .zero
    }

    /**  via MuBranchView::@GestureState touchNow .onChange,
     which also detects end when touchNow is reset to .zero
     */
    func touchUpdate(_ touchNow: CGPoint,
                     _ touchBranch: MuBranchVm?) {

        if      touchNow == .zero  { ended() }
        else if hoverNodeVm == nil { begin() }
        else                       { moved() }

        func begin() {
            setTouchNow(touchNow)
            hoverNodeVm = baseNodeVm.copy()
            rootVm?.begin(touchBranch, touchNow)
            log("touch", [touchNow], terminator: " ")
            log("root", [baseNodeVm.center], terminator: " ")
        }

        func moved() {
            pointNow = touchNow
            rootVm?.moved(touchNow)
        }

        func ended() {
            rootVm?.ended(touchNow)
            pointNow = pointHome
            deltaOfs = .zero
            touchOfs = .zero

            DispatchQueue.main.asyncAfter(deadline: .now() + Layout.animate) {
                touchDone()
            }
        }
        func touchDone() {
            rootVm?.resetRootTimer(delay: 4)
            hoverNodeVm = nil
        }
    }

    func updateHome(_ fr: CGRect) {
        if let root = rootVm {
            pointHome = root.cornerXY(in: fr)
            pointNow = pointHome
            // log("home: ", [pointNow])
        }
    }

    func updateDelta(_ pointDelta: CGPoint) {
        deltaOfs = .zero + pointDelta
        deltaOfs.width += rightSideOffset(for: .limb)
         // log("Δ ", [pointNow, deltaOfs])
    }
}

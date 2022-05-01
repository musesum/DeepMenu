// Created by warren on 10/31/21.

import SwiftUI

/**
 Draggable clone of node withing a branch, which clips at border
 - note: Instead, move clones on space
 */
class MuPilot: ObservableObject {

    @Published var pointNow = CGPoint.zero    // current position
    var pointHome = CGPoint.zero  // starting position of touch
    var alpha: CGFloat { get { (pointNow == pointHome) || (pointNow == .zero) ? 1 : 0 }}

    var root: MuRoot?
    var rootNode: MuNode   // fixed corner node space
    var flyNode: MuNode?  // flying node from root
    var rootBranch: MuBranch

    var touchOfs = CGSize.zero // offset between rootNode and touchNow
    var deltaOfs = CGSize.zero // offset between touch point and center in coord
    var pilotOfs: CGSize { get {
        switch root?.status ?? .root {
            case .root:  return touchOfs
            case .limb:  return deltaOfs
            case .space: return touchOfs
        }}}

    /// adjust offset for root on right side of canvas
    func rightSideOffset(for rootStatus: MuRootStatus) -> CGFloat {
        if let root = root,
           root.status == rootStatus,
           root.corner.contains(.right) {
            return -(2 * Layout.spacing)
        } else {
            return 0
        }
    }

    var touchBranch: MuBranch? // branch which captured DragGesture
    var pointDelta = CGPoint.zero // touch starting position

    init() {
        let rootNodeModel = MuNodeModel("⚫︎") // name changed below
        rootBranch = MuBranch(isRoot: true, axis: .horizontal)
        rootNode = MuNode(.node, rootBranch, rootNodeModel, icon: Layout.hoverRing)
        rootBranch.addNode(rootNode)
    }
    
    func setRoot(_ root: MuRoot) {
        self.root = root
        rootNode.model.setName(from: root.corner)
    }

    /**  via MuBranchView::@GestureState touchNow .onChange,
     which also detects end when touchNow is reset to .zero
     */
    func touchUpdate(_ touchNow: CGPoint,
                     _ touchBranch: MuBranch?) {

        if touchNow == .zero  { ended() }
        else if flyNode == nil { begin() }
        else                  { moved() }

        func begin() {

            pointNow = touchNow
            flyNode = rootNode.copy()
            pointDelta = touchNow
            root?.begin(touchBranch, touchNow)

            touchOfs = CGSize(rootNode.nodeXY - touchNow)
            touchOfs.width += rightSideOffset(for: .root)

            log("touch", [touchNow], terminator: " ")
            log("root", [rootNode.nodeXY], terminator: " ")
        }

        func moved() {
            pointNow = touchNow
            root?.moved(touchNow)
        }

        func ended() {
            root?.ended(touchNow)
            pointNow = pointHome
            deltaOfs = .zero
            touchOfs = .zero

            DispatchQueue.main.asyncAfter(deadline: .now() + Layout.animate) {
                touchDone()
            }
        }
        func touchDone() {
            root?.resetRootTimer(delay: 4)
            flyNode = nil
        }
    }

    func updateHome(_ fr: CGRect) {
        if let root = root {
            pointHome = root.cornerXY(in: fr)
            pointNow = pointHome
            // log("home: ", [pointNow])
        }
    }

    /** center flyNode either on spotlight node or on finger

     MuRoot::alignFlightWithSpotNode(touchNow)
     will set a pointDelta between touchNow and spotXY.
     When there is no spotNode, then the the delta is .zero,
     allowing the flyNode to center on finger, which is
     handled by MuPilotView.flyNode.offset.
     */
    func updateDelta(_ pointDelta: CGPoint) {
        deltaOfs = .zero + pointDelta
        deltaOfs.width += rightSideOffset(for: .limb)
        // log("Δ\(root?.status.description ?? "")", [deltaOfs], terminator: " ")
    }
}

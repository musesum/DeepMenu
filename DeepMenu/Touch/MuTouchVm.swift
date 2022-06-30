// Created by warren on 10/31/21.

import SwiftUI

/// Corner node which follows touch
class MuTouchVm: ObservableObject {

    @Published var dragIconXY = CGPoint.zero /// current position
    public var rootIconXY = CGPoint.zero     /// starting position of touch

    /// hide root icon while hovering elsewhere
    var rootAlpha: CGFloat {
        (dragIconXY == rootIconXY) || (dragIconXY == .zero) ? 1 : 0 }

    var rootVm: MuRootVm?
    var rootNodeVm: MuNodeVm?  /// fixed root node in corner in which to drag from
    var dragNodeVm: MuNodeVm?  /// drag from root with duplicate node icon
    var touchState = MuTouchState() /// begin,moved,end state plus tap count

    private var rootNodeΔ = CGSize.zero /// offset between rootNode and touchNow
    private var spotNodeΔ = CGSize.zero /// offset between touch point and center in coord
    var dragNodeΔ: CGSize = .zero /// weird kludge to compsate for right sight offset

    public func setRoot(_ rootVm: MuRootVm) {
        guard let treeVm = rootVm.treeSpotVm else { return }
        self.rootVm = rootVm
        let testNode = MuNodeTest("⚫︎") //todo: replace with ??
        let branchVm = MuBranchVm.cached(treeVm: treeVm)
        rootNodeVm = MuNodeVm(.node, testNode, branchVm, icon: Layout.hoverRing)
        branchVm.addNodeVm(rootNodeVm)

        dragNodeVm = rootNodeVm?.copy()
        if rootVm.corner.contains(.right) {
            let rightOffset: CGFloat = -(2 * Layout.padding)
            dragNodeΔ = CGSize(width: rightOffset, height: 0)
        }
    }

    /// via MuBranchView::@GestureState touchNow .onChange
    func touchUpdate(_ touchNow: CGPoint) {

        if !touchState.touching    { begin() }
        else if touchNow == .zero  { ended() }
        else                       { moved() }

        alignSpotWithTouch(touchNow)

        func begin() {
            touchState.begin(touchNow)
            rootVm?.touchBegin(touchState)
            // log("touch", [touchNow], terminator: " ")
        }

        func moved() {
            dragIconXY = touchNow
            touchState.moved(touchNow)

            if let rootVm = rootVm {

                let skipBranches = rootVm.nodeSpotVm?.branchVm.skipBranches() ?? false
                if touchState.isFast && skipBranches {
                    // log("🏁", [touchState.speed], terminator: " ")
                } else {
                    rootVm.touchMoved(touchState)
                }
            }
        }

        func ended() {
            touchState.ended()
            rootVm?.touchEnded(touchState)
            dragIconXY = rootIconXY
            spotNodeΔ = .zero // no spotNode to align with
            rootNodeΔ = .zero // go back to rootNode
        }
    }

    /// updated on startup or change in screen orientation
    func updateRootIcon(_ fr: CGRect) {
        rootIconXY = rootVm?.cornerXY(in: fr) ?? .zero
        dragIconXY = rootIconXY
        // log("root: ", [pointNow])
    }
    
    /// either center dragNode icon on spotNode or track finger
    func alignSpotWithTouch(_ touchNow: CGPoint) {

        guard let rootVm = rootVm else {
            return dragIconXY = touchNow
        }
        if !touchState.touching ||
            rootVm.touchElement == .root ||
            rootVm.nodeSpotVm?.type.isLeaf ?? false {

            dragIconXY = rootIconXY

        } else {
            dragIconXY =  rootVm.nodeSpotVm?.center ?? touchNow
        }
    }
}

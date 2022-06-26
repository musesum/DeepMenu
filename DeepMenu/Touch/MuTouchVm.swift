// Created by warren on 10/31/21.

import SwiftUI

/// Corner node which follows touch
class MuTouchVm: ObservableObject {

    @Published var dragIconXY = CGPoint.zero /// current position
    public var homeIconXY = CGPoint.zero     /// starting position of touch

    /// hide home icon while hovering elsewhere
    var homeAlpha: CGFloat {
        (dragIconXY == homeIconXY) || (dragIconXY == .zero) ? 1 : 0 }

    var rootVm: MuRootVm?      // manages
    var homeNodeVm: MuNodeVm?  // fixed home node in corner in which to drag from
    var dragNodeVm: MuNodeVm?  // drag from home with duplicate node icon
    var touchState = MuTouchState() /// begin,moved,end state plus tap count

    private var homeNodeΔ = CGSize.zero // offset between rootNode and touchNow
    private var spotNodeΔ = CGSize.zero // offset between touch point and center in coord
    var dragNodeΔ: CGSize = .zero // weird kludge to compsate for right sight offset

    public func setRoot(_ rootVm: MuRootVm) {
        guard let treeVm = rootVm.treeSpotVm else { return }
        self.rootVm = rootVm
        let homeNode = MuNodeTest("⚫︎") //todo: replace with ??

        let branchVm = MuBranchVm.cached(treeVm: treeVm)

        homeNodeVm = MuNodeVm(.node,
                              homeNode,
                              branchVm,
                              icon: Layout.hoverRing)
        branchVm.addNodeVm(homeNodeVm)
        dragNodeVm = homeNodeVm?.copy()

        if rootVm.corner.contains(.right) {
            let rightOffset: CGFloat = -(2 * Layout.padding)
            dragNodeΔ = CGSize(width: rightOffset, height: 0)
        }
    }

    /** via MuBranchView::@GestureState touchNow .onChange,
     which also detects end when touchNow is reset to .zero
     */
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
            dragIconXY = homeIconXY
            spotNodeΔ = .zero // no spotNode to align with
            homeNodeΔ = .zero // go back to rootNode

            DispatchQueue.main.asyncAfter(deadline: .now() + Layout.animate) {
                self.rootVm?.resetRootTimer(delay: 4)
            }
        }
    }

    func updateHomeIcon(_ fr: CGRect) {
        homeIconXY = rootVm?.cornerXY(in: fr) ?? .zero
        dragIconXY = homeIconXY
        // log("home: ", [pointNow])
    }
    
    /// either center dragNode icon on spotNode or track finger
    func alignSpotWithTouch(_ touchNow: CGPoint) {

        guard let rootVm = rootVm else {
            return dragIconXY = touchNow
        }
        if !touchState.touching ||
            rootVm.touchElement == .home ||
            rootVm.nodeSpotVm?.type.isLeaf ?? false {

            dragIconXY = homeIconXY

        } else if let spotCenter = rootVm.nodeSpotVm?.center {
            dragIconXY = spotCenter
        } else {
            dragIconXY = touchNow
        }
    }
}

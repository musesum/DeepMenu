// Created by warren on 10/31/21.

import SwiftUI

/// Corner node which follows touch
class MuTouchVm: ObservableObject {

    @Published var pointNow = CGPoint.zero    // current position
    public var pointHome = CGPoint.zero  // starting position of touch
    var alpha: CGFloat { (pointNow == pointHome) || (pointNow == .zero) ? 1 : 0 }

    var rootVm: MuRootVm?      //
    var homeNodeVm: MuNodeVm?  // fixed home node in corner in which to drag from
    var dragNodeVm: MuNodeVm?  // drag from home with duplicate node icon

    private var touchOfs = CGSize.zero // offset between rootNode and touchNow
    private var deltaOfs = CGSize.zero // offset between touch point and center in coord

    var pilotOfs: CGSize {
        switch rootVm?.status ?? .root {
            case .root:  return touchOfs
            case .tree:  return deltaOfs
            case .edit:  return .zero
            case .space: return deltaOfs
        }}

    func setRoot(_ rootVm: MuRootVm) {
        guard let treeVm = rootVm.treeSpotVm else { return }
        self.rootVm = rootVm
        let homeNode = MuNodeTest("⚫︎") //todo: replace with ??

        let branchVm = MuBranchVm.cached(treeVm: treeVm)

        homeNodeVm = MuNodeVm(.node,
                              homeNode,
                              branchVm,
                              icon: Layout.hoverRing)

        branchVm.addNodeVm(homeNodeVm)
    }
    

    /// adjust offset for root on right side of canvas
    func rightSideOffset(for rootStatus: MuRootStatus) -> CGFloat {
        guard let rootVm = rootVm else { return 0 }
        if rootVm.status == rootStatus,
           rootVm.corner.contains(.right) {
            return -(2 * Layout.padding)
        } else {
            return 0
        }
    }

    func updatePointNow( _ touchNow: CGPoint) {
        pointNow = touchNow
        let homeCenter = homeNodeVm?.center ?? .zero
        touchOfs = CGSize(homeCenter - touchNow)
        touchOfs.width += rightSideOffset(for: .root)
        deltaOfs = .zero
    }

    /** via MuBranchView::@GestureState touchNow .onChange,
     which also detects end when touchNow is reset to .zero
     */
    func touchUpdate(_ touchNow: CGPoint) {

        if      touchNow == .zero { ended() }
        else if dragNodeVm == nil { begin() }
        else                      { moved() }

        func begin() {
            guard let homeNodeVm = homeNodeVm else { return }
            updatePointNow(touchNow)
            dragNodeVm = homeNodeVm.copy()
            rootVm?.begin(touchNow)  
            log("touch", [touchNow], terminator: " ")
            //log("root", [baseNodeVm.center], terminator: " ")
        }

        func moved() {
            pointNow = touchNow
            rootVm?.moved(pointNow)
        }

        func ended() {
            rootVm?.ended(pointNow) // touchNow is now .zero
            pointNow = pointHome
            deltaOfs = .zero
            touchOfs = .zero

            DispatchQueue.main.asyncAfter(deadline: .now() + Layout.animate) {
                touchDone()
            }
        }
        func touchDone() {
            rootVm?.resetRootTimer(delay: 4)
            dragNodeVm = nil
        }
    }

    func updateHome(_ fr: CGRect) {
        pointHome = rootVm?.cornerXY(in: fr) ?? .zero
        pointNow = pointHome
        // log("home: ", [pointNow])
    }

    func updateDelta(_ pointDelta: CGPoint) {
        deltaOfs = .zero + pointDelta
        deltaOfs.width += rightSideOffset(for: .tree)
         // log("Δ ", [pointNow, deltaOfs])
    }
}

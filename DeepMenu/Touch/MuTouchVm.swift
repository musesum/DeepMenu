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

    /// adjust hovering node icon during drag gesture
    var dragΔ: CGSize {
        switch rootVm?.touchElement ?? .home {
            case .none   : return .zero
            case .home   : return homeNodeΔ
            case .trunks : return .zero
            case .branch : return spotNodeΔ
            case .node   : return spotNodeΔ
            case .leaf   : return .zero
            case .edit   : return .zero
            case .space  : return .zero
            case .edge   : return .zero
        }
    }

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
            updateDragIcon(touchNow)
            dragNodeVm = homeNodeVm.copy()
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
                touchDone()
            }
        }
        func touchDone() {
            rootVm?.resetRootTimer(delay: 4)
            dragNodeVm = nil
        }
    }

    /// adjust offset for root on right side of canvas
    func rightSideOffset(for rootStatus: MuElement) -> CGFloat {
        guard let rootVm = rootVm else { return 0 }
        if rootVm.touchElement == rootStatus,
           rootVm.corner.contains(.right) {
            return -(2 * Layout.padding)
        } else {
            return 0
        }
    }

    func updateDragIcon( _ touchNow: CGPoint) {
        dragIconXY = touchNow
        let homeCenter = homeNodeVm?.center ?? .zero
        homeNodeΔ = CGSize(homeCenter - touchNow)
        homeNodeΔ.width += rightSideOffset(for: .home)
        spotNodeΔ = .zero
    }

    func updateHomeIcon(_ fr: CGRect) {
        homeIconXY = rootVm?.cornerXY(in: fr) ?? .zero
        dragIconXY = homeIconXY
        // log("home: ", [pointNow])
    }

    func updateSpotΔ(_ pointΔ: CGPoint) {
        self.spotNodeΔ = CGSize(pointΔ)
        self.spotNodeΔ.width += rightSideOffset(for: .branch)
        // log("Δ ", [pointNow, deltaOfs])
    }
}

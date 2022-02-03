// Created by warren on 10/31/21.

import SwiftUI

/**
 Draggable clone of pod withing a dock, which clips at border
 - note: Instead, move clones on space
 */
class MuPilot: ObservableObject {

    @Published var pointNow = CGPoint.zero    // current position
    var pointHome = CGPoint.zero  // starting position of touch
    var alpha: CGFloat { get { (pointNow == pointHome) || (pointNow == .zero) ? 1 : 0 }}

    var hub: MuHub?
    var hubPod: MuPod   // fixed corner pod space
    var flyPod: MuPod?  // flying pod from hub
    var hubDock: MuDock

    var touchOfs = CGSize.zero
    var deltaOfs = CGSize.zero // difference between touch point and center in coord
    var pilotOfs: CGSize { get {
        switch hub?.status ?? .hub {
            case .hub:   return touchOfs
            case .spoke: return deltaOfs
            case .space: return touchOfs
        }}}

    func rightSideOffset(for hubStatus: MuHubStatus) -> CGFloat {
        if let hub = hub,
           hub.status == hubStatus,
           hub.corner.contains(.right) {
            return -(2 * Layout.spacing)
        } else {
            return 0
        }
    }

    var touchDock: MuDock? // dock which captured DragGesture
    var pointDelta = CGPoint.zero // touch starting position

    init() {
        let hubPodModel = MuPodModel("⚫︎") // name changed below
        hubDock = MuDock(isHub: true, axis: .horizontal)
        hubPod = MuPod(.hub, hubDock, hubPodModel, icon: Layout.hoverRing)
        hubDock.addPod(hubPod)
    }
    
    func setHub(_ hub: MuHub) {
        self.hub = hub
        hubPod.model.setName(from: hub.corner)
    }

    /**  via MuDockView::@GestureState touchNow .onChange,
     which also detects end when touchNow is reset to .zero
     */
    func touchUpdate(_ touchNow: CGPoint,
                     _ touchDock: MuDock?) {

        if touchNow == .zero  { ended() }
        else if flyPod == nil { begin() }
        else                  { moved() }

        func begin() {

            pointNow = touchNow
            flyPod = hubPod.copy(diameter: Layout.flyDiameter)
            pointDelta = touchNow
            hub?.begin(touchDock, touchNow)

            touchOfs = CGSize(hubPod.podXY - touchNow)
            touchOfs.width += rightSideOffset(for: .hub)
//            if let hub = hub,
//                hub.status == .hub,
//                hub.corner.contains(.right) {
//                touchOfs.width -= 2 * Layout.spacing
//            }
            log("touch", xy: touchNow, terminator: " ")
            //log("fly", xy: flyPod?.podXY ?? .zero, terminator: " ")
            //log("Δ", xy: touchNow-(flyPod?.podXY ?? .zero), terminator: " ")
            log("hub", xy: hubPod.podXY, terminator: " ")
            log("Δ", wh: touchOfs, terminator: " ")
        }

        func moved() {
            pointNow = touchNow
            hub?.moved(touchNow)
        }

        func ended() {
            hub?.ended(touchNow)
            pointNow = pointHome
            deltaOfs = .zero
            touchOfs = .zero

            DispatchQueue.main.asyncAfter(deadline: .now() + Layout.animate) {
                touchDone()
            }
        }
        func touchDone() {
            hub?.resetHubTimer(delay: 4)
            flyPod = nil
        }
    }

    func updateHome(_ fr: CGRect) {
        if let hub = hub {
            pointHome = hub.cornerXY(in: fr)
            pointNow = pointHome
            // log("home: ", xy: pointNow)
        }
    }

    /** center flyPod either on spotlight pod or on finger

     MuHub::alignFlightWithSpotPod(touchNow)
     will set a pointDelta between touchNow and spotXY.
     When there is no spotPod, then the the delta is .zero,
     allowing the flyPod to center on finger, which is
     handled by MuPilotView.flyPod.offset.
     */

    func updateDelta(_ pointDelta: CGPoint) {
        deltaOfs = .zero + pointDelta
        deltaOfs.width += rightSideOffset(for: .spoke)
        log("Δ\(hub?.status.description ?? "")", wh: deltaOfs, terminator: " ")
    }
}

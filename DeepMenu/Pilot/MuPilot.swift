// Created by warren on 10/31/21.

import SwiftUI

/**
 Draggable clone of pod withing a dock, which clips at border
 - note: Instead, move clones on space
 */
class MuPilot: ObservableObject {

    @Published var pointNow = CGPoint.zero    // current position
    var homeHubXY = CGPoint.zero  // starting position of touch

    var hubModel: MuPodModel
    var hubPod: MuPod   // fixed corner pod space
    var flyPod: MuPod?  // flying pod from hub
    var hub: MuHub?
    var hubDock: MuDock

    var deltaOfs = CGSize.zero // difference between touch point and center in coord
    var pilotOfs: CGSize { get { hub?.flightAbove != .spoke ? .zero : deltaOfs }}

    var alpha: CGFloat { get { (pointNow == homeHubXY) || (pointNow == .zero) ? 1 : 0
    }}

    var touchDock: MuDock? // dock which captured DragGesture
    var pointDelta = CGPoint.zero // touch starting position


    init() {
        hubModel = MuPodModel("⚫︎") // name changed below
        hubDock = MuDock(isHub: true, axis: .horizontal)
        hubPod = MuPod(.hub, hubDock, hubModel, icon: Layout.hoverRing)
        hubDock.addPod(hubPod)
    }
    
    func setHub(_ hub: MuHub) {
        self.hub = hub
        switch hub.corner {
            case [.lower, .right]: hubModel.name = "◢"
            case [.lower, .left ]: hubModel.name = "◣"
            case [.upper, .right]: hubModel.name = "◥"
            case [.upper, .left ]: hubModel.name = "◤"

            // reserved for later middling hubs
            case [.upper]: hubModel.name = "▲"
            case [.right]: hubModel.name = "▶︎"
            case [.lower]: hubModel.name = "▼"
            case [.left ]: hubModel.name = "◀︎"
            default:       break
        }
    }

    /**  via MuDockView::@GestureState touchXY .onChange,
     which also detects end when touchXY is reset to .zero
     */
    func touchUpdate(_ touchXY: CGPoint, _ touchDock: MuDock?) {

        if touchXY == .zero   { touchEnd() }
        else if flyPod == nil { touchBegin() }
        else                  { touchMove() }

        func touchBegin() {
            pointNow = touchXY
            flyPod = hubPod.copy(diameter: Layout.flyDiameter)
            pointDelta = touchXY
            hub?.touchBegin(touchDock, touchXY)
        }

        func touchMove() {
            pointNow = touchXY
            hub?.touchMove(touchXY)
        }

        func touchEnd() {
            hub?.touchEnd(touchXY)
            pointNow = homeHubXY
            deltaOfs = .zero

            DispatchQueue.main.asyncAfter(deadline: .now() + Layout.animate) {
                self.touchDone()
            }
        }
    }

    func touchDone() {
        hub?.resetHoverTimeout(delay: 4)
        flyPod = nil
    }

    func updateHome(_ fr: CGRect) {
        if let hub = hub {
            homeHubXY = hub.cornerXY(in: fr)
            pointNow = homeHubXY
            // log("home: ", xy: pointNow)
        }
    }

    /** center flyPod either on spotlight pod or on finger

     MuHub::alignFlightWithSpotPod(touchXY)
     will set a pointDelta between touchXY and spotXY.
     When there is no spotPod, then the the delta is .zero,
     allowing the flyPod to center on finger, which is
     handled by MuPilotView.flyPod.offset.
     */
    func updateDelta(_ pointDelta: CGPoint) {
        deltaOfs = .zero + pointDelta
        if let hub = hub,
           hub.corner.contains(.right) {
            deltaOfs.width -= 2 * Layout.spacing
        }
        //?? log("Δxy", wh: deltaOfs, terminator: "  ")
    }
}

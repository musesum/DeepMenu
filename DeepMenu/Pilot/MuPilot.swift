// Created by warren on 10/31/21.

import SwiftUI

/**
 Draggable clone of pod withing a dock, which clips at border
 - note: Instead, move clones on space
 */
class MuPilot: ObservableObject {

    @Published var touchNowXY = CGPoint.zero    // current position
    var homeHubXY = CGPoint.zero  // starting position of touch

    var hubModel: MuPodModel
    var hubPod: MuPod   // fixed corner pod space
    var flyPod: MuPod?  // flying pod from hub
    var hub: MuHub?
    var hubDock: MuDock

    var deltaOfs = CGSize.zero // difference between touch point and center in coord
    var pilotOfs: CGSize { get { hub?.flightAbove != .spoke ? .zero : deltaOfs }}

    var alpha: CGFloat { get {
        //?? touchBeginTime <= touchEndedTime ? 1 : 0
        (touchNowXY == homeHubXY) || (touchNowXY == .zero) ? 1 : 0
    }}

    var touchDock: MuDock? // dock which captured DragGesture
    var touchBeginXY = CGPoint.zero // touch starting position
    var touchBeginTime = TimeInterval(0) // starting time for tap candidate
    var touchEndedTime = TimeInterval(0) // ending time for tap candidate
    var tap1Time       = TimeInterval(0) // ending time for single tap
    var tap2Time       = TimeInterval(0) // ending time for double tap
    var tap3Time       = TimeInterval(0) // ending time for triple tap

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
            touchNowXY = touchXY
            flyPod = hubPod.copy(diameter: Layout.flyDiameter)
            touchBeginTime = Date().timeIntervalSince1970
            touchBeginXY = touchXY
            hub?.touchBegin(true, touchDock, touchBeginXY, touchNowXY, 0)
        }

        func touchMove() {
            touchNowXY = touchXY
            let deltaTime = Date().timeIntervalSince1970 - touchBeginTime
            hub?.touchBegin(false, touchDock, touchBeginXY, touchNowXY, deltaTime)
        }

        func touchEnd() {
            touchEndedTime = Date().timeIntervalSince1970
            let deltaTime = touchEndedTime - touchBeginTime
            hub?.touchEnd(deltaTime)
            touchNowXY = homeHubXY
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
            touchNowXY = homeHubXY
            // log("home: ", xy: touchNowXY)
        }
    }

    /** center flyPod either on spotlight pod or on finger

     MuHub::alignFlightWithSpotPod(touchXY)
     will set a deltaXY between touchXY and spotXY.
     When there is no spotPod, then the the delta is .zero,
     allowing the flyPod to center on finger, which is
     handled by MuPilotView.flyPod.offset.
     */
    func updateDelta(_ deltaXY: CGPoint) {
        deltaOfs = .zero + deltaXY
        if let hub = hub,
           hub.corner.contains(.right) {
            deltaOfs.width -= 2 * Layout.spacing
        }
        //?? log("Δxy", wh: deltaOfs, terminator: "  ")
    }
}



//  MuHub.swift
// Created by warren 10/13/21.
import SwiftUI

class MuHub: ObservableObject, Equatable {
    let id = MuIdentity.getId()
    static func == (lhs: MuHub, rhs: MuHub) -> Bool {
        return lhs.id == rhs.id
    }

    @Published var status = MuHubStatus.hub
    func updateStatus(_ newValue: MuHubStatus, _ debug: Int) {
        if status != newValue {
            status = newValue
            print(status.description+String(debug), terminator: " ")
        }
    }

    var corner: MuCorner
    var spokes = [MuSpoke]() // usually a vertical and horizon spoke
    var spotSpoke: MuSpoke?  // most recently used spoke

    let pilot = MuPilot()   // captures touch events to dispatch to this hub
    var spotPod: MuPod?     // current spotlight pod
    var touchDock: MuDock?  // dock that is capturing touch events
    var touch: MuTouch = MuTouch()

    init(_ corner: MuCorner, docks: [MuDock]?) {

        self.corner = corner
        pilot.setHub(self)

        if let docks = docks {
            spokes = docks.map({ dock in
                MuSpoke(docks: [dock], hub: self)
            })
        }
        
        updateOffsets()
    }

    /**
     Adjust spoke offsets iPhone and iPad to avoid false positives, now that springboard adds a corner hotspot for launching the notes app.
     Also, adjust pilot offsets for home hub and for flying.

     The fly ring is bigger than the home ring, so the offsets are different. To test alignment, comment out the `.opacity(...)` statements in MuDockView. The fly ring should come to home after dragDone and encircle the home ring.
     */
    func updateOffsets() {

        let idiom = UIDevice.current.userInterfaceIdiom

        let margin = 2 * Layout.spacing
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

        for spoke in spokes {
            spoke.offset = (spoke.axis == .horizontal ? hOfs : vOfs)
        }
    }

    func cornerXY(in frame: CGRect) -> CGPoint {

        let idiom = UIDevice.current.userInterfaceIdiom
        let margin = 2 * Layout.spacing
        let x = (idiom == .pad ? margin : 0)
        let y = ((corner.contains(.upper) && idiom == .phone) ||
                  (corner.contains(.lower) && idiom == .pad))  ? margin : 0
        let w = frame.size.width
        let h = frame.size.height
        let s = Layout.spacing
        let r = Layout.diameter / 2

        switch corner {
            case [.lower, .right]: return CGPoint(x: w - x - r - s, y: h - y - r - s)
            case [.lower, .left ]: return CGPoint(x:     x + r + s, y: h - y - r - s)
            case [.upper, .right]: return CGPoint(x: w - x - r - s, y:     y + r + s)
            case [.upper, .left ]: return CGPoint(x:     x + r + s, y:     y + r + s)
            default: return .zero
        }
    }

    var anchorShift = CGSize.zero
    var lastLog = "" // compare to avoid duplicate log statements

    var beginDepths: ClosedRange<Int> { get {
        var maxDepth = 0
        var minDepth = 99 // instead of Int.max for readable logs
        for spoke in spokes {
            let depth = spoke.depthShown
            maxDepth = max(maxDepth,depth)
            minDepth = min(minDepth,depth)
        }
        return minDepth...maxDepth
    }}

    ///
    var touchDockDepth: CGFloat { get {
        guard let dock = touchDock else { return  0 }
        let docks = dock.spoke?.docks ?? [dock]
        var touchDockDepth = CGFloat(0)
        for docki in docks {
            if  dock.id == docki.id { break }
            touchDockDepth += 1
        }
        return touchDockDepth
    }}
    // touch began at first encountered dock
    func begin(_ dock: MuDock?,
               _ touchNow: CGPoint) {

        touch.begin(touchNow)

        guard let dock = dock else {
            // touching hub 
            updateStatus(.hub, 1)
            toggleDocks(lowestDepth: 1) //TODO: -- fix by determining current state
            return
        }
        self.touchDock = dock

        // depth of dock
        anchorShift = dock.dockShift
        anchorDock()
        updateHub()
        spotPod?.superSelect() // bookmark route through super pods
    }

    // touch began at first encountered dock
    func moved(_ pointNow: CGPoint) {

        touch.moved(pointNow)
        anchorDock()
        updateHub()
    }

    func ended(_ pointNow: CGPoint) {

        touch.ended(pointNow)

        if touch.tapCount > 0 {

            resetHubTimer(delay: 8)
            if let touchDock = touchDock {
                touchDock.beginTap()
            } else {
                toggleDocks(lowestDepth: 0)
            }
        }
        updateStatus(.hub, 2)
        touchDock = nil
    }

    func updateDockShift(_ dockOffset: CGSize) {
        // update each dock's `dockShift` offset
        guard let dock = touchDock else { return }
        let docks = dock.spoke?.docks ?? [dock]
        var dockIndex = CGFloat(0)
        for dock in docks {
            let factor = (dockIndex < touchDockDepth) ? dockIndex/touchDockDepth : 1
            dock.dockShift = dockOffset * factor
            dockIndex += 1
        }
    }

    func getRanges(_ dock: MuDock) -> (ClosedRange<CGFloat>,
                                       ClosedRange<CGFloat>) {
        // calc ranges
        let oneSpace = Layout.diameter + Layout.spacing * 3 // distance between docks
        let maxSpace = touchDockDepth * oneSpace // maximum distance up to dock
        let vert = dock.border.axis == .vertical
        let hori = dock.border.axis == .horizontal
        let left = corner.contains(.left)
        let upper = corner.contains(.upper)

        let rangeW = (vert ? left
                      ? -maxSpace...0   // vertical left
                      : 0...maxSpace    // vertical right
                      : 0...0)          // hoizontal or hub

        let rangeH = (hori ? upper
                      ? -maxSpace...0   // horizontal upper
                      : 0...maxSpace    // horizontal lower
                      : 0...0)          // vertical or hub

        return (rangeW, rangeH)
    }

    /// set fixed point for stretching/folding docks
    func anchorDock() {

        if let touchDock = touchDock {
            let deltaTouch = CGSize(touch.pointDelta)
            let (rangeW, rangeH) = getRanges(touchDock)
            let dockOffset = (deltaTouch + anchorShift).clamp(rangeW, rangeH)

            let begin = touch.pointDelta == .zero
            let title = touchDock.title
            if begin { log(title, dockOffset, rangeW, rangeH) }
            // else  { log(title, dockOffset, rangeW, rangeH) }
            updateDockShift(dockOffset)
        }
        func log(_ title: String,
                 _ dockOffset: CGSize,
                 _ rangeWidth: ClosedRange<CGFloat>,
                 _ rangeHeight: ClosedRange<CGFloat>) {

            let touchDelta  = touch.pointDelta.string()
            let anchorShift = anchorShift.string()
            let dockOffset = dockOffset.string() // clamped
            let clamp = "\(rangeWidth.string()) \(rangeHeight.string())"

            let newLog = "\(title) \(touchDelta) \(anchorShift) \(dockOffset) \(clamp)"
            if lastLog != newLog {
                lastLog = newLog
                print(newLog, terminator: " ")
            }
        }
    }

    /// save time with going from depth 0 to depth 1
    var toggleDepth01Time = TimeInterval(0)

    func toggleDocks(lowestDepth: Int) {
        // going from depth 0 -> 1
        if lowestDepth == 1, beginDepths == 0...0 {
            toggleDepth01Time = Date().timeIntervalSince1970
        }
        // skip going from 1 -> 0  if recently went from 0 -> 1
        else if lowestDepth == 0 {
            let deltaTime = Date().timeIntervalSince1970 - toggleDepth01Time
            // already expanded from 0 to 1 at beginning of tap
            if deltaTime < MuTouch.tapInterval {
                return
            }
        }

        let depth = (beginDepths == 1...1 ? lowestDepth : 1)
        for spoke in spokes {
            spoke.showDocks(depth: depth)
        }
        spotSpoke = nil 
    }

    /// [begin | moved] >> updateHub
    func updateHub() {

        resetHubTimer()

        if isExploring() {
            if let spotNext = followTouch(touch.pointNow)  {
                spotPod = spotNext
                // print(".", terminator: "")
            }
            spotPod?.superSpotlight()
        }
        alignFlightWithSpotPod(touch.pointNow)
    }


    func followTouch(_ touchNow: CGPoint) -> MuPod? {

        func setSpotSpoke(_ spokeNext: MuSpoke) {
            
            for hideSpoke in spokes {
                if hideSpoke.id != spokeNext.id {
                    hideSpoke.showDocks(depth: 0)
                }
                spotSpoke = spokeNext
                spotSpoke?.showDocks(depth: 99) 
            }
            updateStatus(.spoke, 3)
        }

        // begin -------------------------------------------

        // have been exploring a spoke already
        if let spotSpoke = spotSpoke {
            if let nearestPod = spotSpoke.nearestPod(touchNow, touchDock) {
                // still within same spotlight spoke
                updateStatus(.spoke, 6)
                return nearestPod
            } else {
                // no longer on spotSpoke
                for spoke in spokes {
                    // skip spotlight spoke
                    if spoke.id == spotSpoke.id { continue }
                    // look for nearestPod
                    if let nearestPod = spoke.nearestPod(touchNow, touchDock) {
                        // found a pod on another spoke
                        setSpotSpoke(spoke)
                        return nearestPod
                    }
                }
            }
        }
        // starting out from hub
        else {
            for spoke in spokes {
                if let nearestPod = spoke.nearestPod(touchNow, touchDock)  {
                    setSpotSpoke(spoke)
                    return nearestPod
                }
            }
        }
        // hovering over hub
        if pilot.pointHome.distance(touchNow) < Layout.spotArea {
            if status != .hub {
                updateStatus(.hub, 4)
                toggleDocks(lowestDepth: 1)
            } else {
                updateStatus(.hub, -4)
            }
            pilot.hub?.alignFlightWithSpotPod(touchNow)
        }
        else {
            updateStatus(.space, 5)
        }
        return nil
    }

    /// either center flight icon on spotPod or track finger
    private func alignFlightWithSpotPod(_ touchNow: CGPoint) {

        if let spotXY = spotPod?.podXY {
            let pointDelta = spotXY - touchNow
            pilot.updateDelta(pointDelta)
        } else {
            pilot.updateDelta(.zero)
        }
    }

    /// cursor has not wandered past current spotlight pod?
    func isExploring() -> Bool {

        guard let spotPod   = spotPod   else { return true }
        guard let touchDock = touchDock else { return true }
        let pointNow = touch.pointNow
        let pointDelta = touch.pointDelta

        // still on same spotlight pod
        let spotDistance = abs(spotPod.podXY.distance(pointNow))
        if spotDistance < Layout.zone { return false }

        // on different pod inside same dock
        if touchDock.bounds.contains(pointNow) { return true }

        // touch began at hub
        if touchDock.isHub == true { return true }

        switch touchDock.border.axis  { // explore outward (✶) or hover inward (⌂)
            case .vertical:
                return (corner.contains(.right)
                        ? pointDelta.x < 0
                        : pointDelta.x > 0)

            case .horizontal:
                return (corner.contains(.lower)
                        ? pointDelta.y < 0
                        : pointDelta.y > 0)
        }
    }

    /// timer for auto-folding docks back into spokes
    var hubTimer: Timer?

    /// cancel timer that auto-tucks in docks
    func resetHubTimer(delay: TimeInterval = -1) {
        #if false
        hubTimer?.invalidate()
        
        if delay < 0 { return } // started dragging, so don't finish old one

        func resetting(_ timer: Timer) {
            for spoke in spokes {
                spoke.showDocks(depth: 0)
            }
            updateStatus(.hub, 9)
        }
        hubTimer = Timer.scheduledTimer(withTimeInterval: delay,
                                          repeats: false,
                                          block: resetting)
        #endif
    }
}


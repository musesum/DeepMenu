// Created by warren 10/27/21.
import SwiftUI

class MuSpoke: Identifiable, ObservableObject {
    let id = MuIdentity.getId()

    @Published var docks: [MuDock]
    var hub: MuHub? // control tower hub
    var axis: Axis  // vertical or horizontal
    var reverse = false // sort order of docks
    var level = CGFloat(1) // starting level for docks
    var offset = CGSize(width: 0, height: 0)
    var depthShown = 0 // levels of docks shown
    var spotPod: MuPod? // current pod under pilot's flyPod

    init(docks: [MuDock],
         hub: MuHub) {

        self.docks = docks
        self.hub = hub
        self.axis = docks.first?.border.axis ?? .horizontal

        // how to progress from edge to center
        reverse = (axis == .horizontal
                   ? hub.corner.contains(.lower) ? true : false
                   : hub.corner.contains(.right) ? true : false)
        for dock in docks {
            dock.updateSpoke(self, hub)
        }
        showDocks(depth: 1)
    }
    
    func nearestPod(_ podXY: CGPoint, _ touchDock: MuDock?) -> MuPod? {
        var skipPreDocks = touchDock?.spoke?.id == id //??

        for dock in docks {
            if dock.show == false { continue } //??
            if skipPreDocks && (touchDock?.id != dock.id) { continue }
            else { skipPreDocks = false }

            if let nextPod = dock.findHover(podXY) {
                if spotPod?.id != nextPod.id {
                    spotPod = nextPod
                    refreshDocks(nextPod.dock, nextPod)
                }
                return spotPod
            }
        }
        return nil
    }

    func refreshDocks(_ spotDock: MuDock, _ spotPod: MuPod) {

        // tapped on spotlight
        if let nextDock = spotDock.nextDock,
            nextDock.show == true, // nextDock is also shown (spoke.depth > 1)
           let subId = nextDock.spotPod?.model.id,
           let nowId = spotPod.model.subNow?.id,
           subId == nowId {
            // all subDocks are the same
            return
        }
        spotDock.spotPod = spotPod
        // remove old sub docks 
        while docks.last?.id != spotDock.id {
            docks.removeLast()
        }
        var newDocks = [MuDock]()
        expandDocks(spotPod, docks.last,  &newDocks, level + 1)
        if newDocks.count > 0 {
            docks.append(contentsOf: newDocks)
            // unfold docks
            var lag = TimeInterval(0)
            for dock in docks {
                Delay(lag) { dock.show = true }
                lag += Layout.lagStep
            }
        }
    }

    /// add a dock to selected pod and follow selected kid
    func expandDocks(_ spotPod: MuPod?,
                     _ prevDock: MuDock?,
                     _ newDocks: inout [MuDock],
                     _ level: CGFloat) {
        
        guard let spotPod = spotPod else { return }
        self.level = level
        spotPod.spotlight = true
        
        if let subModels = spotPod.model.subModels,
           subModels.count > 0 {
            
            let newDock = MuDock(prevDock: prevDock,
                                 suprPod: spotPod,
                                 subModels: subModels,
                                 spoke: self,
                                 hub: hub,
                                 level: level + 1,
                                 show: false,
                                 axis: axis)

            newDocks.append(newDock)
            if let nextModel = spotPod.model.subNow {
                // TODO: use ordered dictionary?
                let filter = newDock.subPods.filter { $0.model.id == nextModel.id }
                newDock.spotPod = filter.first
                expandDocks(newDock.spotPod, newDock, &newDocks, level + 1)
            }
        }
    }

    func showDocks(depth depthNext: Int) {

        var lag = TimeInterval(0)
        var newDocks = [MuDock]()

        logBegin()
        if      depthShown < depthNext { expandDocks() }
        else if depthShown > depthNext { contractDocks() }
        logEnd()

        func expandDocks() {
            var countUp = 0
            for dock in docks {
                if countUp < depthNext {
                    newDocks.append(dock)
                    Delay(lag) { dock.show = true }
                    lag += Layout.lagStep
                } else {
                    dock.show = false
                }
                countUp += 1
            }
            depthShown = min(countUp, depthNext)
        }
        func contractDocks() {
            var countDown = docks.count
            for dock in docks.reversed() {
                if countDown > depthNext,
                   dock.show == true {
                    Delay(lag) { dock.show = false }
                    lag += Layout.lagStep
                }
                countDown -= 1
            }
            depthShown = depthNext
        }
        func logBegin() {
            let isHub = docks.first?.isHub == true
            let vert = (axis == .vertical)
            let axStr = isHub ? " ⃝" : vert ? "V⃝" : "H⃝"
            print ("\(axStr) \(depthShown)⇨\(depthNext)", terminator: "=")
        }
        func logEnd() {
            print (depthShown, terminator: " ")
        }
    }

}

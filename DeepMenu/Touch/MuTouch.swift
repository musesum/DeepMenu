//  Created by warren on 1/15/22.

import SwiftUI

class MuTouch {

    static let tapThreshold = TimeInterval(0.5) // tap time threshold
    private var timeBegin = TimeInterval(0) // starting time for tap candidate
    private var timeDelta = TimeInterval(0) // time elapsed since beginning
    private var timeEnded = TimeInterval(0) // ending time for tap candidate

    private var moveThreshold = CGFloat(5)  // move distance to reset tapCount
    private var pointBegin = CGPoint.zero   // where touch started

    var tapCount  = 0  // number of taps
    var pointNow   = CGPoint.zero   // current position of touch
    var pointDelta = CGPoint.zero   // pointNow - pointBegin
    var touching: Bool { get { return timeEnded > timeBegin }}

    func begin(_ pointNow: CGPoint) {

        self.pointNow = pointNow
        let timeNow = Date().timeIntervalSince1970
        if (timeNow - timeEnded) > MuTouch.tapThreshold {
            tapCount = 0 // not a tap
        }
        timeBegin = timeNow
        timeDelta = 0
        pointBegin = pointNow
        pointDelta = .zero
        logTime("🟢")
    }
    
    func moved(_ pointNow: CGPoint) {

        self.pointNow = pointNow
        pointDelta = pointNow - pointBegin
        timeDelta = Date().timeIntervalSince1970 - timeBegin
        if pointNow.distance(pointBegin) > moveThreshold {
            tapCount = 0
        }
        //logTime("🟡")
    }

    func ended(_ pointNow: CGPoint) {

        self.pointNow = pointNow
        pointDelta = pointNow - pointBegin

        timeEnded = Date().timeIntervalSince1970
        timeDelta = timeEnded - timeBegin
        tapCount = tapped ? tapCount + 1 : 0
        logTime("🔴")
    }

    var tapped: Bool { get {
        let tapping = timeDelta < MuTouch.tapThreshold
        if tapping {
            logTime("🟣" + (tapCount < 3 ? "¹²³"[tapCount] : String(tapCount)))
        }
        return tapping
    }}

    func logTime(_ symbol: String) {
        print(String(format: "\n%.2f \(symbol)", timeDelta), terminator: " ")
    }
}

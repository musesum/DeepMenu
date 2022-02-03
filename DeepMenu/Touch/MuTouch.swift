//  Created by warren on 1/15/22.

import SwiftUI

class MuTouch {

    static let tapInterval = TimeInterval(0.5) // tap time threshold
    var timeBegin = TimeInterval(0) // starting time for tap candidate
    var timeDelta = TimeInterval(0) // time elapsed since beginning
    var timeEnded = TimeInterval(0) // ending time for tap candidate
    var tapCount  = 0               // number of taps

    var pointBegin = CGPoint.zero   // where touch started
    var pointNow   = CGPoint.zero   // current position of touch
    var pointDelta = CGPoint.zero   // pointNow - pointBegin
    var moveThreshold = CGFloat(5)  // move distance to reset tapCount

    func begin(_ pointNow: CGPoint) {
        self.pointNow = pointNow
        let timeNow = Date().timeIntervalSince1970
        if (timeNow - timeEnded) > MuTouch.tapInterval {
            tapCount = 0
        }
        timeBegin = timeNow
        timeDelta = 0
        pointBegin = pointNow
        pointDelta = .zero
        log("🟢")
    }
    func moved(_ pointNow: CGPoint) {
        self.pointNow = pointNow
        pointDelta = pointNow - pointBegin
        timeDelta = Date().timeIntervalSince1970 - timeBegin
        if pointNow.distance(pointBegin) > moveThreshold {
            tapCount = 0
        }
        //log("🟡")
    }

    func ended(_ pointNow: CGPoint) {

        self.pointNow = pointNow
        pointDelta = pointNow - pointBegin

        timeEnded = Date().timeIntervalSince1970
        timeDelta = timeEnded - timeBegin
        tapCount = tapped ? tapCount + 1 : 0
        log("🔴")
    }

    var tapped: Bool {
        let tapping = timeDelta < MuTouch.tapInterval
        if tapping {
            log("🟣" + (tapCount < 3 ? "¹²³"[tapCount] : String(tapCount)))
        }
        return tapping
    }

    func log(_ symbol: String) {
        print(String(format: "\n%.2f \(symbol)", timeDelta), terminator: " ")
    }
}

//  Created by warren on 1/15/22.

import SwiftUI

class MuTouch {

    var timeBegin = TimeInterval(0) // starting time for tap candidate
    var timeDelta = TimeInterval(0) // time elapsed since beginning
    var timeEnded = TimeInterval(0) // ending time for tap candidate

    let tapInterval = TimeInterval(0.5) // tap time threshold
    var tapCount = 0                    // number of taps

    var pointBegin = CGPoint.zero
    var pointNow   = CGPoint.zero
    var pointDelta = CGPoint.zero


    func begin(_ pointNow: CGPoint) {
        self.pointNow = pointNow
        let timeNow = Date().timeIntervalSince1970
        if (timeEnded - timeNow) > tapInterval {
            tapCount = 0
        }
        timeBegin = timeNow
        timeDelta = 0
        pointBegin = pointNow
        pointDelta = .zero
    }
    func moved(_ pointNow: CGPoint) {
        self.pointNow = pointNow
        pointDelta = pointNow - pointBegin
        timeDelta = Date().timeIntervalSince1970 - timeBegin
    }
    func ended(_ pointNow: CGPoint) {
        self.pointNow = pointNow
        pointDelta = pointNow - pointBegin
        timeEnded = Date().timeIntervalSince1970
        timeDelta = timeEnded - timeBegin
        if timeDelta < tapInterval {
            tapCount += 1
        }
        print(String(format: "\n%.2f 🔴 ", timeDelta))
    }
}

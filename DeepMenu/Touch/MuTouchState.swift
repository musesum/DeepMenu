//  Created by warren on 1/15/22.

import SwiftUI

class MuTouchState {

    static let tapThreshold = TimeInterval(0.5) // tap time threshold
    private let speedThreshold = CGFloat(400) // test to skip branches
    private var timeBegin = TimeInterval(0) // starting time for tap candidate
    private var timeLast = TimeInterval(0)  // time of last reported touch
    private var timeEnded = TimeInterval(0) // ending time for tap candidate
    private var timeBeginDelta = TimeInterval(0) // time elapsed since beginning
    private var timeLastDelta = TimeInterval(0) // time elapsed since last interval

    private var moveThreshold = CGFloat(5)  // move distance to reset tapCount
    private var pointBegin = CGPoint.zero   // where touch started

    var tapCount = 0  // number of taps
    var pointNow = CGPoint.zero // current position of touch
    var isFast = false

    private var pointLast = CGPoint.zero  // last reported touch while moving
    private var touchSpeed = CGFloat.zero // speed while moving
    private var pointBeginDelta = CGPoint.zero // pointNow - pointBegin
    private var pointLastDelta = CGPoint.zero // pointNow - pointLast

    var touching: Bool { return timeEnded > timeBegin }

    func begin(_ pointNow: CGPoint) {

        self.pointNow = pointNow
        let timeNow = Date().timeIntervalSince1970
        if (timeNow - timeEnded) > MuTouchState.tapThreshold {
            tapCount = 0 // not a tap
        }
        timeBegin = timeNow
        timeLast = timeNow
        timeBeginDelta = 0
        timeLastDelta = 0
        pointBegin = pointNow
        pointLast = pointNow
        pointBeginDelta = .zero
        pointLastDelta = .zero

        log(time: 0, "🟢")
    }

    private func updateTimePoint(_ point: CGPoint) {

        let timeNow = Date().timeIntervalSince1970
        timeBeginDelta =  timeNow - timeBegin
        timeLastDelta = timeNow - timeLast
        timeLast = timeNow

        pointNow = point
        pointBeginDelta = point - pointBegin
        pointLastDelta = pointLast - point
        pointLast = point

        let distance = pointLastDelta.distance(.zero)
        let speed = CGFloat(distance/timeLastDelta)
        isFast = speed > speedThreshold
       // if isFast { log("🏁", [speed], terminator: " ") }
    }

    func moved(_ point: CGPoint) {

        updateTimePoint(point)
        if point.distance(pointBegin) > moveThreshold {
            tapCount = 0
        }
    }

    func ended(_ point: CGPoint) {

        updateTimePoint(point)
        pointBeginDelta = point - pointLast
        timeEnded = timeLast
        timeBeginDelta = timeEnded - timeBegin
        tapCount = tapped ? tapCount + 1 : 0
        log(time: timeBeginDelta, "🔴")
    }

    var tapped: Bool {
        let tapping = timeBeginDelta < MuTouchState.tapThreshold
        if tapping {
            log(time: timeBeginDelta,
                "🟣" + (tapCount < 3
                        ? "¹²³"[tapCount]
                        : String(tapCount)))
        }
        return tapping
    }

}

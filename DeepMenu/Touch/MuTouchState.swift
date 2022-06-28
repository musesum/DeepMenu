//  Created by warren on 1/15/22.

import SwiftUI

public enum MuTouchPhase { case none, begin, moved, ended }

public class MuTouchState {

    static let tapThreshold = TimeInterval(0.5) // tap time threshold
    private let speedThreshold = CGFloat(400) // test to skip branches

    private var timeBegin = TimeInterval(0) // starting time for tap candidate
    private var timePrev = TimeInterval(0)  // previous time of reported touch
    private var timeEnded = TimeInterval(0) // ending time for tap candidate
    private var timeBeginΔ = TimeInterval(0) // time elapsed since beginning
    private var timePrevΔ = TimeInterval(0) // time elapsed since last interval

    private var moveThreshold = CGFloat(5)  // move distance to reset tapCount
    private var pointBegin = CGPoint.zero   // where touch started

    var tapCount = 0  // number of taps
    var isFast = false // move fast to skip branches
    var pointNow = CGPoint.zero // current position of touch
    var speed = CGFloat.zero
    var phase = MuTouchPhase.none

    private var pointPrev = CGPoint.zero  // last reported touch while moving
    private var touchSpeed = CGFloat.zero // speed while moving
    private var pointBeginΔ = CGPoint.zero // pointNow - pointBegin
    private var pointPrevΔ = CGPoint.zero // pointNow - pointLast

    var touching: Bool { return timeBegin > timeEnded }

    func begin(_ pointNow: CGPoint) {
        phase = .begin
        self.pointNow = pointNow
        let timeNow = Date().timeIntervalSince1970
        if (timeNow - timeEnded) > MuTouchState.tapThreshold {
            tapCount = 0 // not a tap
        }
        timeBegin = timeNow
        timePrev = timeNow
        timeBeginΔ = 0
        timePrevΔ = 0
        pointBegin = pointNow
        pointPrev = pointNow
        pointBeginΔ = .zero
        pointPrevΔ = .zero

        log(time: 0, "🟢")
    }

    private func updateTimePoint(_ point: CGPoint) {

        let timeNow = Date().timeIntervalSince1970
        timeBeginΔ =  timeNow - timeBegin
        timePrevΔ = timeNow - timePrev
        timePrev = timeNow

        pointNow = point
        pointBeginΔ = point - pointBegin
        pointPrevΔ = pointPrev - point
        pointPrev = point

        let distance = pointPrevΔ.distance(.zero)
        speed = CGFloat(distance/timePrevΔ)
        isFast = speed > speedThreshold
    }

    func moved(_ point: CGPoint) {
        phase = .moved
        updateTimePoint(point)
        if point.distance(pointBegin) > moveThreshold {
            tapCount = 0
        }
    }

    func ended() {
        phase = .ended
        updateTimePoint(pointNow)
        pointBeginΔ = pointNow - pointPrev
        timeEnded = timePrev
        timeBeginΔ = timeEnded - timeBegin
        updateTapCount()
        log(time: timeBeginΔ, "🔴")
    }

    func updateTapCount() {
        if timeBeginΔ < MuTouchState.tapThreshold {
            tapCount += 1
            log(time: timeBeginΔ, "🟣" + superScript(tapCount))
        } else {
            tapCount = 0
        }
    }

}

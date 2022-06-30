//  Created by warren on 1/15/22.

import SwiftUI

public class MuTouchState {

    public enum MuTouchPhase { case none, begin, moved, ended }
    let tapThreshold = TimeInterval(0.5) /// tap time threshold
    let speedThreshold = CGFloat(400) /// test to skip branches
    let moveThreshold = CGFloat(5)   /// move distance to reset tapCount

    var touchCount = 0  // count touchBegin's within tapThreshold
    var tapCount = 0    // count touchEnd's within tapThreshold
    var isFast = false  // is moving fast to skip branches
    var pointNow = CGPoint.zero // current position of touch
    var phase = MuTouchPhase.none // begin, moved, ended
    var touching: Bool { return timeBegin > timeEnded }

    private var timeBegin  = TimeInterval(0) /// starting time for tap candidate
    private var timePrev   = TimeInterval(0) /// previous time of touch
    private var timeEnded  = TimeInterval(0) /// ending time for tap candidate
    private var timeBeginΔ = TimeInterval(0) /// time elapsed since beginning
    private var timeEndedΔ = TimeInterval(0) /// time elapsed since last end
    private var timePrevΔ  = TimeInterval(0) /// time elapsed since last interval

    private var pointBegin  = CGPoint.zero /// where touch started
    private var pointPrev   = CGPoint.zero /// last reported touch while moving
            var pointBeginΔ = CGPoint.zero /// pointNow - pointBegin
    private var pointPrevΔ  = CGPoint.zero /// pointNow - pointLast
    private var touchSpeed  = CGFloat.zero /// speed of movement

    func begin(_ pointNow: CGPoint) {
        phase = .begin
        self.pointNow = pointNow
        let timeNow = Date().timeIntervalSince1970
        if (timeNow - timeEnded) > tapThreshold {
            tapCount = 0 // not a tap
        }
        timeBegin = timeNow
        timeEndedΔ = timeBegin - timeEnded
        updateTouchCount()

        timePrev = timeNow
        timeBeginΔ = 0
        timePrevΔ = 0

        pointBegin = pointNow
        pointPrev = pointNow
        pointBeginΔ = .zero
        pointPrevΔ = .zero

        log(time: 0, "🟢")
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
        log(time: timeBeginΔ, "🛑")
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
        touchSpeed = CGFloat(distance/timePrevΔ)
        isFast = touchSpeed > speedThreshold
    }

    func updateTouchCount() {
        if timeEndedΔ < tapThreshold {
            touchCount += 1
            log(time: timeEndedΔ, "🔷" + superScript(touchCount))
        } else {
            touchCount = 0
        }
    }
    func updateTapCount() {
        if timeBeginΔ < tapThreshold {
            tapCount += 1
            log(time: timeBeginΔ, "🔶" + superScript(tapCount))
        } else {
            tapCount = 0
        }
    }

}

//  Created by warren on 5/10/22.

import SwiftUI

/// 2d XY control
class MuLeafVxyVm: MuLeafVm {
    
    var thumb: CGPoint = .zero /// normalized to 0...1
    var proto: MuNodeProtocol?
    var ranges = [String : ClosedRange<Float>]()

    init (_ node: MuNode,
          _ branchVm: MuBranchVm,
          _ prevVm: MuNodeVm?,
          icon: String = "") {
        
        super.init(.vxy, node, branchVm, prevVm, icon: icon)
        node.proxies.append(self)  // MuLeaf delegate for setting value
        proto = node.proto ?? prevVm?.node.proto

        if let nameRanges = proto?.getRanges(named: ["x","y"]) {
            for (name,range) in nameRanges {
                ranges[name] = range
            }
        }
        let x = normalizeNamed("x",ranges["x"])
        let y = normalizeNamed("y",ranges["y"])
        thumb = CGPoint(x: x, y: y)
    }
    func normalizeNamed(_ name: String, _ range: ClosedRange<Float>?) -> CGFloat {
        let val = (proto?.getAny(named: name) as? Float) ?? .zero
        let norm = scale(val, from: range ?? 0...1, to: 0...1)
        return CGFloat(norm)
    }
    func expand(named: String, _ value: CGFloat) -> Float {

        let range = ranges[named] ?? 0...1
        let result = scale(Float(value), from: 0...1, to: range)
        return result
    }

    /// Tick marks for double touch alignments
    /// shown at center, corner, and sides.
    /// So: NW, N, NE, E, SE, S, SW, W, Center
    var nearestTick: CGPoint {
        CGPoint(x: round(thumb.x * 2) / 2,
                y: round(thumb.y * 2) / 2)
    }

    /// ticks above and below nearest tick,
    /// but never on panel border or thumb border
    lazy var ticks: [CGSize] = {
        var result = [CGSize]()
        let runway = self.panelVm.runwayXY
        let radius = self.panelVm.thumbRadius
        let span = CGFloat(0.5)
        let margin = Layout.radius - 2
        for w in stride(from: CGFloat(0), through: 1, by: span) {
            for h in stride(from: CGFloat(0), through: 1, by: span) {

                let tick = CGSize(width:  w * runway.x,
                                  height: h * runway.y)
                result.append(tick)
            }
        }
        return result
    }()

    /// normalized thumb radius
    lazy var thumbRadius: CGFloat = {
        Layout.diameter / max(runwayBounds.height,runwayBounds.width) / 2
    }()

    /// touchBegin inside thumb will probably be off-center.
    /// To avoid a sudden jump, thumbBeginΔ adds an offset.
    var thumbBeginΔ = CGPoint.zero
}

extension MuLeafVxyVm: MuLeafProxy {

    /// user touch gesture inside runway
    func touchLeaf(_ touchState: MuTouchState) {

        if touchState.phase == .begin {

            if touchState.touchCount == 1 {
                tapThumb()
                updateView()
                editing = true
            } else {
                touchThumbBegin()
                updateView()
                editing = true
            }
        } else if touchState.phase != .ended {
            touchThumbNext()
            updateView()
            editing = true
        } else {
            editing = false
        }

        func tapThumb() {
            let touchDelta = touchState.pointNow - runwayBounds.origin
            let thumbPrior = panelVm.normalizeTouch(xy: touchDelta)
            thumb = quantizeThumb(thumbPrior)
            thumbBeginΔ = thumb - thumbPrior
        }

        /// user touched control, translate to normalized thumb (0...1)
        func touchThumbNext() {
            if !runwayBounds.contains(touchState.pointNow) {
                // slowly erode thumbBegin∆ when out of bounds
                thumbBeginΔ = thumbBeginΔ * 0.85
            }
            let touchDelta = touchState.pointNow - runwayBounds.origin
            thumb = panelVm.normalizeTouch(xy: touchDelta) + thumbBeginΔ
        }
        func touchThumbBegin() {
            let thumbPrev = thumb
            let touchDelta = touchState.pointNow - runwayBounds.origin
            let thumbNext = panelVm.normalizeTouch(xy: touchDelta)
            let touchedInsideThumb = thumbNext.distance(thumbPrev) < thumbRadius
            thumbBeginΔ = touchedInsideThumb ? thumbPrev - thumbNext : .zero
            thumb = thumbNext + thumbBeginΔ
        }

        /// double touch will align thumb to center, corners or sides.
        func quantizeThumb(_ point: CGPoint) -> CGPoint {
            let x = round(point.x * 2) / 2
            let y = round(point.y * 2) / 2
            return CGPoint(x: x, y: y)
        }
    }

    /// update from model - not touch
    func updateLeaf(_ any: Any) {
        if let p = any as? CGPoint {
            editing = true
            let x = scale(Float(p.x), from: ranges["x"] ?? 0...1, to: 0...1)
            let y = scale(Float(p.y), from: ranges["y"] ?? 0...1, to: 0...1)
            thumb = CGPoint(x: CGFloat(x), y: CGFloat(y))
            editing = false
        }
    }

    // View -----------------------

    /// expand normalized thumb to View coordinates and update outside model
    func updateView() {
        let x = expand(named: "x", thumb.x)
        let y = expand(named: "y", thumb.y)
        proto?.setAnys([("x", x),("y", y)])
    }
    override func valueText() -> String {
        String(format: "x %.2f y %.2f",
               expand(named: "x", thumb.x),
               expand(named: "y", thumb.y))
    }
    override func thumbOffset() -> CGSize {
        CGSize(width:  thumb.x * panelVm.runway,
               height: (1-thumb.y) * panelVm.runway)
    }
}

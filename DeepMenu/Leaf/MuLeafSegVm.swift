//  Created by warren on 12/10/21.

import SwiftUI

/// segmented control
class MuLeafSegVm: MuLeafVm {

    var thumb = CGFloat(0)
    var proto: MuNodeProtocol?
    var range: ClosedRange<Float> = 0...1

    init (_ node: MuNode,
          _ branchVm: MuBranchVm,
          _ prevVm: MuNodeVm?,
          icon: String = "") {

        super.init(.seg, node, branchVm, prevVm, icon: icon)
        node.proxies.append(self) // MuLeaf delegate for setting value
        proto = node.proto ?? prevVm?.node.proto
        range = proto?.getRange(named: type.name) ?? 0...1
        thumb = normalizeValue
        updatePanelSizes()
    }

    /// get current value and normalize 0...1 based on defined range
    var normalizeValue: CGFloat {
        let val = (proto?.getAny(named: type.name) as? Float) ?? .zero
        return CGFloat(scale(val, from: range, to: 0...1))
    }
    /// normalize point to 0...1 based on defined range
    func normalizeTouch(_ point: CGPoint) -> CGFloat {
        let v = panelVm.axis == .vertical ? point.y : point.x
        return panelVm.normalizeTouch(v: v)
    }
    
    /// scale up normalized to defined range
    var expanded: Float {
        scale(Float(nearestTick), from: 0...1, to: range)
    }

    lazy var count: CGFloat = { CGFloat(range.upperBound - range.lowerBound) }()


    /// adjust branch and panel sizes for smaller segments
    func updatePanelSizes() {
        let size = panelVm.axis == .vertical
        ? CGSize(width: 1, height: count.clamped(to: 2...4))
        : CGSize(width: count.clamped(to: 2...4), height: 1)

        branchVm.panelVm.aspectSz = size
        panelVm.aspectSz = size
        branchVm.show = true // refresh view
    }

    var nearestTick: CGFloat { return round(thumb*count)/count }

    //var offset: CGSize { CGSize(width: 0, height: nearestTick * runway) }

    /// ticks above and below nearest tick,
    /// but never on panel border or thumb border
    lazy var ticks: [CGSize] = {

        var result = [CGSize]()
        let runway = panelVm.runway
        let radius = panelVm.thumbRadius
        let count = range.upperBound - range.lowerBound
        if count < 1 { return [] }
        let span = (1/max(1,count))
        let margin = Layout.radius - 2

        for v in stride(from: 0, through: Float(1), by: span) {

            let ofs = CGFloat(v) * runway + radius
            let size = panelVm.axis == .vertical
            ? CGSize(width: margin, height: ofs)
            : CGSize(width: ofs, height: margin)
            result.append (size)
        }
        return result
    }()

    /// normalized thumb radius
    lazy var thumbRadius: CGFloat = {
        Layout.diameter / max(runwayBounds.height,runwayBounds.width) / 2
    }()

    /// touchBegin inside thumb will Not move thumb.
    /// So, determing delta from center at touchState.begin
    var thumbBeginΔ = CGFloat.zero
}

extension MuLeafSegVm: MuLeafProxy {

    /// user touch gesture inside runway
    func touchLeaf(_ touchState: MuTouchState) {

        if touchState.phase == .begin {
            touchThumbBegin()
            updateView()
            editing = true
        } else if touchState.phase != .ended {
            touchThumbNext()
            updateView()
            editing = true
        } else {
            editing = false
        }

        /// user touched control, translate to normalized thumb (0...1)
        func touchThumbNext() {
            if !runwayBounds.contains(touchState.pointNow) {
                // slowly erode thumbBegin∆ when out of bounds
                thumbBeginΔ = thumbBeginΔ * 0.85
            }
            let touchDelta = touchState.pointNow - runwayBounds.origin
            thumb = normalizeTouch(touchDelta) + thumbBeginΔ
        }
        func touchThumbBegin() {
            let thumbPrev = thumb
            let touchDelta = touchState.pointNow - runwayBounds.origin
            let thumbNext = normalizeTouch(touchDelta)
            let touchedInsideThumb = abs(thumbNext.distance(to: thumbPrev)) < thumbRadius
            thumbBeginΔ = touchedInsideThumb ? thumbPrev - thumbNext : .zero
            thumb = thumbNext + thumbBeginΔ
        }
    }
    func updateLeaf(_ any: Any) {
        if let v = any as? Float {
            editing = true
            thumb = CGFloat(scale(v, from: range, to: 0...1))
            editing = false
        }
    }

    // View -----------------------

    /// expand normalized thumb to View coordinates and update outside model
    func updateView() {
        proto?.setAny(named: type.name, expanded)
    }
    override func valueText() -> String {
        range.upperBound > 1
        ? String(format: "%.f", scale(Float(thumb), from: 0...1, to: range))
        : String(format: "%.1f", thumb)
    }
    override func thumbOffset() -> CGSize {
        panelVm.axis == .vertical
        ? CGSize(width: 1, height: (1-thumb) * panelVm.runway)
        : CGSize(width: thumb * panelVm.runway, height: 1)
    }
}


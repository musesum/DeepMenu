//  Created by warren on 12/10/21.

import SwiftUI

/// 1d slider control
public class MuLeafValVm: MuLeafVm {

    var thumb = CGFloat(0)
    var proto: MuNodeProtocol?
    var range: ClosedRange<Float> = 0...1

    init (_ node: MuNode,
          _ branchVm: MuBranchVm,
          _ prevVm: MuNodeVm?,
          icon: String = "") {
        
        super.init(.val, node, branchVm, prevVm, icon: icon)
        node.proxies.append(self) // MuLeaf delegate for setting value
        proto = node.proto ?? prevVm?.node.proto
        range = proto?.getRange(named: nodeType.name) ?? 0...1
        thumb = normalizeNamed(nodeType.name)
    }

    func normalizeNamed(_ name: String) -> CGFloat {
        let val = (proto?.getAny(named: name) as? Float) ?? .zero
        let norm = scale(val, from: range, to: 0...1)
        return CGFloat(norm)
    }

    var expanded: Float {
        scale(Float(thumb), from: 0...1, to: range)
    }

    func normalizeTouch(_ point: CGPoint) -> CGFloat {
        let v = panelVm.axis == .vertical ? point.y : point.x
        let vv = panelVm.normalizeTouch(v: v)
        return vv 
    }

    /// normalized thumb radius
    lazy var thumbRadius: CGFloat = {
        Layout.diameter / max(runwayBounds.height,runwayBounds.width) / 2
    }()

    /// touchBegin inside thumb will Not move thumb.
    /// So, determing delta from center at touchState.begin
    var thumbBeginΔ = CGFloat.zero
}

// Model
extension MuLeafValVm: MuLeafProxy {

    /// user touch gesture inside runway
    public func touchLeaf(_ touchState: MuTouchState) {

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

    public func updateLeaf(_ any: Any) {
        if let v = any as? Float {
            editing = true
            thumb = CGFloat(scale(v, from: range, to: 0...1))
            editing = false
        }
    }
    // View

    /// expand normalized thumb to View coordinates and update outside model
    public func updateView() {
        proto?.setAny(named: nodeType.name, expanded)
    }
    public override func valueText() -> String {
        String(format: "%.2f", expanded)
    }
    public override func thumbOffset() -> CGSize {
        panelVm.axis == .vertical
        ? CGSize(width: 1, height: (1-thumb) * panelVm.runway)
        : CGSize(width: thumb * panelVm.runway, height: 1)
    }
}


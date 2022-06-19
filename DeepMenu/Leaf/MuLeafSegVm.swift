//  Created by warren on 12/10/21.

import SwiftUI

func scale(_ value: Float, fr: ClosedRange<Float>, to: ClosedRange<Float>) -> Float {
    let val = Float(value)

        let toSpan = to.upperBound - to.lowerBound // to
        let frSpan = fr.upperBound - fr.lowerBound // from
        let from01 = (val.clamped(to: fr) - fr.lowerBound) / frSpan
        let scaled = (from01 * toSpan) + to.lowerBound
        return scaled
}

/// segmented control
class MuLeafSegVm: MuNodeVm {

    var thumb = CGFloat(0)
    var value: MuNodeValue?
    var range: ClosedRange<Float> = 0...1
    lazy var count: CGFloat = { CGFloat(range.upperBound - range.lowerBound) }()

    var status: String {
        range.upperBound > 1
        ? String(format: "%.f", scale(Float(thumb), fr: 0...1, to: range))
        : String(format: "%.1f", thumb)
    }
    
    init (_ node: MuNode,
          _ branchVm: MuBranchVm,
          _ prevVm: MuNodeVm?,
          icon: String = "") {

        super.init(.seg, node, branchVm, prevVm, icon: icon)
        node.leaves.append(self) // MuLeaf delegate for setting value
        value = node.value ?? prevVm?.node.value
        range = value?.getRange(named: type.name) ?? 0...1
        thumb = normalizedValue
        updatePanelSizes()
    }
    /// get current value and normalize 0...1 based on defined range
    var normalizedValue: CGFloat {
        let val = (value?.getAny(named: type.name) as? Float) ?? .zero
        return CGFloat(scale(val, fr: range, to: 0...1))
    }
    /// normalize point to 0...1 based on defined range
    func normalizedTouch(_ point: CGPoint) -> CGFloat {
        let v = panelVm.axis == .vertical ? point.y : point.x
        return panelVm.normalizeTouch(v: v)
    }
    /// scale up normalized to defined range
    var scaled: Float {
        scale(Float(nearestTick), fr: 0...1, to: range)
    }
    var offset: CGSize {
        panelVm.axis == .vertical
        ? CGSize(width: 0, height: thumb * panelVm.runway)
        : CGSize(width: thumb * panelVm.runway, height: 0)
    }

    /// adjust branch and panel sizes for smaller segments
    func updatePanelSizes() {
        guard let branchVm = branchVm else { return }
        let size = panelVm.axis == .vertical
        ? CGSize(width: 1, height: count.clamped(to: 2...4))
        : CGSize(width: count.clamped(to: 2...4), height: 1)

        branchVm.panelVm.axisSize = size
        panelVm.axisSize = size
        branchVm.show = true // refresh view
    }

    var nearestTick: CGFloat { return round(thumb*count)/count }

    //var offset: CGSize { CGSize(width: 0, height: nearestTick * runway) }

    /// ticks above and below nearest tick,
    /// but never on panel border or thumb border
    lazy var ticks: [CGFloat] = {
        var result = [CGFloat]()
        let count = range.upperBound - range.lowerBound
        if count < 1 { return [] }
        let span = 1/max(1,count)
        for index in stride(from: Float(0), through: 1, by: span) {
            let ofs = CGFloat(index) * panelVm.runway +  panelVm.thumbRadius
            result.append( ofs)
        }
        return result
    }()



}

extension MuLeafSegVm: MuLeafProtocol {

    func touchLeaf(_ point: CGPoint) {

        if point != .zero {
            editing = true
            thumb = normalizedTouch(point)
            value?.setAny(named: type.name, scaled)
        } else {
            editing = false
        }
    }
    func updateLeaf(_ any: Any) {
        if let v = any as? Float {
            editing = true
            thumb = CGFloat(scale(v, fr: range, to: 0...1))
            editing = false
        }
    }
}

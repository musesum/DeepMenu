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
        thumb = CGFloat((value?.getAny(named: type.name) as? Float) ?? .zero)
    }
    lazy var runway: CGFloat = {
        panelVm.yRunway()
    }()

    var nearestTick: CGFloat {
        let count = CGFloat(range.upperBound - range.lowerBound)
        return round(thumb*count)/count
    }
    var offset: CGSize {
        CGSize(width: 0, height: nearestTick * runway)
    }

    /// ticks above and below nearest tick,
    /// but never on panel border or thumb border
    lazy var ticks: [CGFloat] = {
        var result = [CGFloat]()
        let count = range.upperBound - range.lowerBound
        if count < 2 { return [] }
        let span = 1/max(1,count)
        for index in stride(from: Float(0), through: 1, by: span) {
            let ofs = CGFloat(index) * runway +  panelVm.thumbRadius
            result.append( ofs)
        }
        return result
    }()

}

extension MuLeafSegVm: MuLeafProtocol {

    func touchLeaf(_ point: CGPoint) {

        if point != .zero {
            editing = true
            thumb = panelVm.normalizeTouch(v: point.y) //TODO: axis ??
            let scaled = CGFloat(scale(Float(thumb), fr: 0...1, to: range))
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

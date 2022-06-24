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
        node.leaves.append(self) // MuLeaf delegate for setting value
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
    func normalizedTouch(_ point: CGPoint) -> CGFloat {
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
        let span = CGFloat(1/max(1,count))
        let margin = Layout.diameter/2 - 2
        for v in stride(from: 0, through: 1, by: span) {
            let ofs = v * runway + radius
            let size = panelVm.axis == .vertical
            ? CGSize(width: margin, height: ofs)
            : CGSize(width: ofs, height: margin)
            result.append (size)
        }
        return result
    }()

}
// Model
extension MuLeafSegVm: MuLeafModelProtocol {

    func touchLeaf(_ point: CGPoint) {
        if point != .zero {
            editing = true
            thumb = normalizedTouch(point)
            proto?.setAny(named: type.name, expanded)
        } else {
            editing = false
        }
    }
    func updateLeaf(_ any: Any) {
        if let v = any as? Float {
            editing = true
            thumb = CGFloat(scale(v, from: range, to: 0...1))
            editing = false
        }
    }
}
// View
extension MuLeafSegVm: MuLeafViewProtocol {

    override func valueText() -> String {
        range.upperBound > 1
        ? String(format: "%.f", scale(Float(thumb), from: 0...1, to: range))
        : String(format: "%.1f", thumb)
    }
    override func thumbOffset() -> CGSize {
        panelVm.axis == .vertical
        ? CGSize(width: 0, height: (1-thumb) * panelVm.runway)
        : CGSize(width: thumb * panelVm.runway, height: 0)
    }
}


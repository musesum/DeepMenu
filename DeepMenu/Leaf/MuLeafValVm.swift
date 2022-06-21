//  Created by warren on 12/10/21.

import SwiftUI

// 1d slider control
class MuLeafValVm: MuLeafVm {

    var thumb = CGFloat(0)
    var value: MuNodeValue?

    var range: ClosedRange<Float> = 0...1

    init (_ node: MuNode,
          _ branchVm: MuBranchVm,
          _ prevVm: MuNodeVm?,
          icon: String = "") {
        
        super.init(.val, node, branchVm, prevVm, icon: icon)
        node.leaves.append(self) // MuLeaf delegate for setting value
        value = node.value ?? prevVm?.node.value
        range = value?.getRange(named: type.name) ?? 0...1
        thumb = normalizeValue
    }

    var normalizeValue: CGFloat {
        let val = (value?.getAny(named: type.name) as? Float) ?? .zero
        let norm = scale(val, fr: range, to: 0...1)
        return CGFloat(norm)
    }

    var scaled: Float {
        scale(Float(thumb), fr: 0...1, to: range)
    }

    func normalizeTouch(_ point: CGPoint) -> CGFloat {
        let v = panelVm.axis == .vertical ? point.y : point.x
        let vv = panelVm.normalizeTouch(v: v)
        return vv 
    }
}
// Model
extension MuLeafValVm: MuLeafModelProtocol {

    func touchLeaf(_ point: CGPoint) {
        if point != .zero {
            editing = true
            thumb = normalizeTouch(point)
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
// View
extension MuLeafValVm: MuLeafViewProtocol {

    override func valueText() -> String {
        return String(format: "%.2f", scaled)
    }

    override func thumbOffset() -> CGSize {
        return panelVm.axis == .vertical
        ? CGSize(width: 0, height: (1-thumb) * panelVm.runway)
        : CGSize(width: thumb * panelVm.runway, height: 0)
    }
}


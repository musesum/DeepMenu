//  Created by warren on 12/10/21.

import SwiftUI

// 1d slider control
class MuLeafValVm: MuNodeVm {

    var thumb = CGFloat(0)
    var value: MuNodeValue?
    var status: String { String(format: "%.2f", scaled) }
    var range: ClosedRange<Float> = 0...1

    init (_ node: MuNode,
          _ branchVm: MuBranchVm,
          _ prevVm: MuNodeVm?,
          icon: String = "") {
        
        super.init(.val, node, branchVm, prevVm, icon: icon)
        node.leaves.append(self) // MuLeaf delegate for setting value
        value = node.value ?? prevVm?.node.value
        range = value?.getRange(named: type.name) ?? 0...1
        thumb = normalizedValue
    }

    var normalizedValue: CGFloat {
        let val = (value?.getAny(named: type.name) as? Float) ?? .zero
        return CGFloat(scale(val, fr: range, to: 0...1))
    }

    var offset: CGSize {
        panelVm.axis == .vertical
        ? CGSize(width: 0, height: thumb * panelVm.runway)
        : CGSize(width: thumb * panelVm.runway, height: 0)
    }

    var scaled: Float {
        scale(Float(thumb), fr: 0...1, to: range)
    }
    func normalized(_ point: CGPoint) -> CGFloat {
        let v = panelVm.axis == .vertical ? point.y : point.x
        return panelVm.normalizeTouch(v: v)
    }

}

extension MuLeafValVm: MuLeafProtocol {

    func touchLeaf(_ point: CGPoint) {
        if point != .zero {
            editing = true
            thumb = normalized(point)
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

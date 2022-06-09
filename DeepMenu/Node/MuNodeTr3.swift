// Created by warren on 10/17/21.

import SwiftUI
import Tr3
import Par

/// shared between 1 or more MuNodeVm
class MuNodeTr3: MuNode {

    var tr3: Tr3
    var caching = false
    var axis: Axis = .vertical

    init(_ tr3: Tr3,
         parent: MuNode? = nil) {

        self.tr3 = tr3
        super.init(name: tr3.name,
                   parent: parent)

        tr3.addClosure(getting)
        value = self // setup delegate for MuValue protocol
    }
}
extension MuNodeTr3: MuNodeValue {
    func set(_ any: Any) {

        var options = Tr3SetOptions([.activate, .zero1])
        if caching { options.insert(.cache) }
        switch any {
            case let p as CGPoint: tr3.setVal(p, options, Visitor(id))
            case let f as CGFloat: tr3.setVal(f, options, Visitor(id))
            default: break
        }
    }
    /// callback from tr3
    func getting(_ any: Any, _ visitor: Visitor) {

        // print("\(tr3.scriptLineage(3)).\(tr3.id): \(tr3.FloatVal() ?? -1)")

        if let tr3 = any as? Tr3,
           visitor.newVisit(id) {
            let p = tr3.CGPointVal() ?? .zero
            leaf?.updatePoint(p)
        }
    }
    /// called from view model to get current value
    func get() -> CGFloat { return tr3.CGFloatVal() ?? .zero }
    func get() -> CGPoint { return tr3.CGPointVal() ?? .zero }
    func range() -> ClosedRange<Int> { return 0...1 } // for segmented control
}

extension Tr3 {

    func hash() -> Int {
        let path = scriptLineage(999)
        var hasher = Hasher()
        hasher.combine(path)
        let hash = hasher.finalize()
        print(path+String(format: ": %i", hash))
        return hash
    }
}

extension Tr3 {

    func components() -> [String: Any] {
        var result = [String: Any]()
        if let exprs = val as? Tr3Exprs {
            for expr in exprs.exprs {
                let type = MuNodeType(expr.name)
                if type != .none {
                    result["type"] = type
                } else if expr.name == "icon" {
                    result["icon"] = expr.string
                }
            }
        }
        return result
    }
}

// Created by warren on 10/17/21.

import SwiftUI
import Tr3
import Par

/// shared between 1 or more MuNodeVm
class MuNodeTr3: MuNode {

    var tr3: Tr3

    init(_ tr3: Tr3,
         parent: MuNode? = nil,
         callback: @escaping CallAny = { _ in return }) {

        self.tr3 = tr3
        super.init(name: tr3.name, parent: parent, callback: callback)
    }
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

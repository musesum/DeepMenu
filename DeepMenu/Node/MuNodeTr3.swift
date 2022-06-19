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
    override func leafType() -> MuNodeType? {
        if let name = tr3.getName(in: MuNodeLeaves) {
            return  MuNodeType(name)
        }
        return nil
    }
}
extension MuNodeTr3: MuNodeValue {

    func setPoint(_ point: CGPoint) {
        var options = Tr3SetOptions([.activate, .zero1])
        if caching { options.insert(.cache) }
        tr3.setVal(point, options, Visitor(id))
    }

    func getPoint() -> CGPoint {
        return tr3.CGPointVal() ?? .zero
    }

    func setAny(named: String, _ any: Any) {

        var options = Tr3SetOptions([.activate, .zero1])
        if caching { options.insert(.cache) }
        tr3.setVal((named, any), options, Visitor(id)) //TODO: get Visitor(id) from caller
    }

    func getAny(named: String) -> Any? {
        let any = tr3.component(named: named)
        if let val = any as? Tr3ValScalar {
            return val.num
        } else if let num = any as? Float {
            return num
        } else {
            return any
        }
    }

    func getRange(named: String) -> ClosedRange<Float> {
        
        let any = tr3.component(named: named)
        if let val = any as? Tr3ValScalar {
            return val.min...val.max
        } else if let val = tr3.val as? Tr3ValScalar {
            return val.min...val.max
        } else {
            return 0...1
        }
    }

    /// callback from tr3
    ///
    /// even though the val
    func getting(_ any: Any, _ visitor: Visitor) {
        // print("\(tr3.scriptLineage(3)).\(tr3.id): \(tr3.FloatVal() ?? -1)")
        if let tr3 = any as? Tr3 {
            //TODO: visitor.newVisit(id) {
            
            for child in children {
                for leaf in child.leaves {
                    if let p = tr3.CGPointVal() {
                        
                        leaf.updateLeaf(p)
                        
                    } else if let name = tr3.getName(in: MuNodeLeaves),
                              let any = tr3.component(named: name) {
                        
                        if let val = any as? Tr3ValScalar {

                            let num = val.num
                            leaf.updateLeaf(num)
                            
                        } else {
                            leaf.updateLeaf(any)
                        }
                    }
                }
            }
        }
    }
}



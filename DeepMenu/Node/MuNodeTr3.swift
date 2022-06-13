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

    func setNamed(_ name: String, _ any: Any) {
        var options = Tr3SetOptions([.activate, .zero1])
        if caching { options.insert(.cache) }
        tr3.setVal((name, any), options, Visitor(id))
    }

    func getNamed(_ named: String) -> Any? {
        let result = tr3.component(named: named)
        if let num = result as? CGFloat {
            return CGFloat(num)
        } else {
            return result
        }
    }

    
    func getRange() -> ClosedRange<Int> {
        return 0...1 //??
    }

    /// callback from tr3
    ///
    /// even though the val
    func getting(_ any: Any, _ visitor: Visitor) {
        // print("\(tr3.scriptLineage(3)).\(tr3.id): \(tr3.FloatVal() ?? -1)")
        if let tr3 = any as? Tr3 {
            //??? visitor.newVisit(id) {
            
            for child in children {
                for leaf in child.leaves {
                    if let p = tr3.CGPointVal() {
                        
                        leaf.updateLeaf(p)
                        
                    } else if let name = tr3.getName(in: MuNodeLeaves),
                              let any = tr3.component(named: name) {
                        if let num = any as? Float {
                            leaf.updateLeaf(CGFloat(num))
                        } else {
                            leaf.updateLeaf(any)
                        }
                    }
                }
            }
        }
    }
}



// Created by warren on 10/17/21.

import SwiftUI
import MuMenu
import Tr3 // version from 0.2.32
import Par

/// shared between 1 or more MuNodeVm
public class MuNodeTr3: MuNode {

    var tr3: Tr3
    var caching = false
    var axis: Axis = .vertical

    init(_ tr3: Tr3,
         parent: MuNode? = nil) {

        self.tr3 = tr3

        super.init(name: tr3.name,
                   icon: MuNodeTr3.makeTr3Icon(tr3),
                   parent: parent)

        tr3.addClosure(getting) // update node value closuer
        proto = self // setup delegate for MuValue protocol
    }
    public override func leafType() -> MuNodeType? {
        
        if let name = tr3.getName(in: MuNodeLeaves) {
            return  MuNodeType(rawValue: name)
        } else if tr3.contains(names: ["x","y"]) {
            return MuNodeType.vxy
        }
        return nil
    }

    static func makeTr3Icon(_ tr3: Tr3) -> MuIcon {
        let components = tr3.components(named: ["symbol", "image", "abbrv", "cursor"])
        for (key,value) in components {
            if let value = value as? String {
                switch key {
                    case "symbol": return MuIcon(.symbol, named: value)
                    case "image" : return MuIcon(.image,  named: value)
                    case "abbrv" : return MuIcon(.abbrv,  named: value)
                    case "cursor": return MuIcon(.cursor, named: value)
                    default: continue
                }
            }
        }
        return MuIcon(.none, named: "")
    }
}

extension MuNodeTr3: MuNodeProtocol {

    public func setAny(named: String,_ any: Any) {

        var options = Tr3SetOptions([.activate, .zero1])
        if caching { options.insert(.cache) }
        tr3.setAny((named,any), options, Visitor(id)) //TODO: get Visitor(id) from caller
    }
    public func setAnys(_ anys: [(String,Any)]) {

        var options = Tr3SetOptions([.activate, .zero1])
        if caching { options.insert(.cache) }
        tr3.setAnys(anys, options, Visitor(id)) //TODO: get Visitor(id) from caller
    }
    public func getAny(named: String) -> Any? {

        let any = tr3.component(named: named)

        if let val = any as? Tr3ValScalar {
            return val.num
        } else if let num = any as? Float {
            return num
        } else {
            return nil
        }
    }
    public func getAnys(named: [String]) -> [(String,Any?)] {

        var result = [(String,Any?)]()
        let comps = tr3.components(named: named)
        for (name, any) in comps {
            if let val = any as? Tr3ValScalar {
                result.append((name, val.num))
            } else if let num = any as? Float {
                result.append((name, num))
            } else {
                result.append((name, nil))
            }
        }
        return result
    }
    public func getRange(named: String) -> ClosedRange<Float> {

        let any = tr3.component(named: named)

        if let val = any as? Tr3ValScalar {
            return val.min...val.max
        } else if let val = tr3.val as? Tr3ValScalar {
            return val.min...val.max
        } else {
            return 0...1
        }
    }
    public func getRanges(named: [String]) -> [(String,ClosedRange<Float>)] {

        var result = [(String,ClosedRange<Float>)]()

        let comps = tr3.components(named: named)
        for (name, any) in comps {
            if let val = any as? Tr3ValScalar {
                result.append((name, val.min...val.max))
            } else if let val = tr3.val as? Tr3ValScalar {
                result.append((name, val.min...val.max))
            } else {
                result.append((name, 0...1))
            }
        }
        return result
    }

    /// callback from tr3
    ///
    /// even though the val
    public func getting(_ any: Any, _ visitor: Visitor) {
        // print("\(tr3.scriptLineage(3)).\(tr3.id): \(tr3.FloatVal() ?? -1)")
        if let tr3 = any as? Tr3 {
            //TODO: visitor.newVisit(id) {
            
            for child in children {
                for proxy in child.proxies {
                    if let p = tr3.CGPointVal() {

                        //TODO: get rid of CGPoint test? -- Would require returning all components and thus impacts the single name components, below. May become important in the future, with complex exprs, like a midi.input.note.on on(num 0...127, velo 0...127, chan 1...32, port 1...16, time 0)

                        proxy.updateLeaf(p)
                        
                    } else if let name = tr3.getName(in: MuNodeLeaves),
                              let any = tr3.component(named: name) {
                        
                        if let val = any as? Tr3ValScalar {

                            let num = val.num
                            proxy.updateLeaf(num)
                            
                        } else {
                            proxy.updateLeaf(any)
                        }
                    }
                }
            }
        }
    }
}



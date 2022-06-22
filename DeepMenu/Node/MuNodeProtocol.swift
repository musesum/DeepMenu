//  Created by warren on 6/9/22.

import SwiftUI
import Par

/// exchange values with outside model
public protocol MuNodeProtocol {
    
    func setPoint(_ point: CGPoint)
    func getPoint() -> CGPoint
    
    func setAny(named: String,_ any: Any)
    func setAnys(_ anys: [(String, Any)])
    func getAny(named: String) -> Any?
    func getAnys(named: [String]) -> [(String, Any?)]
    func getRange(named: String) -> ClosedRange<Float> 
    func getRanges(named: [String]) -> [(String, ClosedRange<Float>)]
    
    func getting(_ any: Any, _ visitor: Visitor)
}

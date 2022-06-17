//  Created by warren on 6/9/22.

import SwiftUI
import Par

public protocol MuNodeValue {

    func setPoint(_ point: CGPoint)
    func getPoint() -> CGPoint

    func setAny(named: String,_ any: Any)
    func getAny(named: String) -> Any?

    func getting(_ any: Any, _ visitor: Visitor)
    func getRange(named: String) -> ClosedRange<Float> // for segmented control
}

//  Created by warren on 6/9/22.

import SwiftUI
import Par

public protocol MuNodeValue {

    func setPoint(_ point: CGPoint)
    func getPoint() -> CGPoint

    func setNamed(_ named: String,_ any: Any)
    func getNamed(_ named: String) -> Any?

    func getting(_ any: Any, _ visitor: Visitor)
    func getRange() -> ClosedRange<Int> // for segmented control
}

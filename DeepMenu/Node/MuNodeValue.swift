//  Created by warren on 6/9/22.

import SwiftUI
import Par

public protocol MuNodeValue {
    func set(_ any: Any)
    func getting(_ any: Any, _ visitor: Visitor)
    func get() -> CGFloat
    func get() -> CGPoint
    func range() -> ClosedRange<Int> // for segmented control
}

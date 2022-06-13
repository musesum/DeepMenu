//  Created by warren on 6/9/22.

import SwiftUI

public protocol MuLeafProtocol {
    func touchLeaf(_ point: CGPoint) /// update from user interaction
    func updateLeaf(_ point: Any) /// update from model
}


// Created by warren on 10/31/21.

import SwiftUI

struct Layout {
    static let diameter: CGFloat = 40
    static let spacing: CGFloat = 4
    static var zone: CGFloat { get { diameter + spacing }}
    static let flyDiameter: CGFloat = 46
    static let animate = CGFloat(0.33)
    static let hoverRing = "icon.ring.roygbiv"
    static let lagStep = TimeInterval(1.0/32.0) // sixteenth of a second
}

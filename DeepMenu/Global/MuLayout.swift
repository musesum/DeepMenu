// Created by warren on 10/31/21.

import SwiftUI

struct Layout {
    static let titleHeight: CGFloat = 40
    static let diameter: CGFloat = 40
    static let spacing: CGFloat = 4
    static var spotArea: CGFloat { get { diameter + spacing * 2 } }
    static var zone: CGFloat { get { diameter + spacing } }
    static let animate = CGFloat(0.33)
    static let hoverRing = "icon.ring.roygbiv"
    static let lagStep = TimeInterval(1.0/32.0) // sixteenth of a second
    static let panelFill = Color(white: 0.01, opacity: 0.5)
    static func flash() -> Animation { return .easeInOut(duration: 0.20)}

    static func fillColor(_ high: Bool) -> Color {
        let color = (high
                     ? Color(white: 1.0, opacity: 1.00)
                     : Color(white: 0.6, opacity: 0.80))
        return color
    }

    static func strokeColor(_ high: Bool) -> Color {
        let color = (high
                     ? Color(white: 0.6, opacity: 0.80)
                     : Color(white: 0.4, opacity: 0.80))
        return color
    }

    static func strokeWidth(_ high: Bool) -> CGFloat {
        return(high ? 2.0 : 1.0)
    }
}

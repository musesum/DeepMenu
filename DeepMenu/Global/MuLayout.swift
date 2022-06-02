// Created by warren on 10/31/21.

import SwiftUI

struct Layout {

    static let titleHeight: CGFloat = 40

    static let diameter: CGFloat = 40

    /// margin between nodes and branches
    static let spacing: CGFloat = 4

    /// distance from center while inside node
    static let insideNode: CGFloat = 24

    static let animate = CGFloat(0.33)
    static let hoverRing = "icon.ring.roygbiv"
    static let lagStep = TimeInterval(1.0/32.0) // sixteenth of a second
    static let panelFill = Color(white: 0.01, opacity: 0.5)

    /// quick animatin for fla
    static var flashAnim: Animation { get { .easeInOut(duration: 0.20) }}

    static func fillColor(_ high: Bool) -> Color {
        let color = (high
                     ? Color(white: 1.0, opacity: 1.00)
                     : panelFill)
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

//  Created by warren on 12/20/21.

import SwiftUI

class MuBorder {
    var type: MuBorderType
    var axis: Axis
    var count: CGFloat

    // changed by type
    lazy var diaFactor: CGFloat = [.polar,.rect].contains(type) ? 4 : 1
    lazy var diameter = Layout.diameter * diaFactor
    lazy var spacing: CGFloat = Layout.spacing
    lazy var cornerRadius: CGFloat = (type == .polar
                                      ? (diameter + spacing) / 2
                                      : Layout.diameter / 2)

    lazy var vert = (axis == .vertical)
    lazy var length = (diameter + 2 * spacing)
    lazy var runway = length * count + margin * (count-1)
    lazy var maxW = vert ? length : runway
    lazy var maxH = vert ? runway : length
    lazy var minW = maxW/8
    lazy var minH = maxH/8

    var margin = CGFloat(0) // overlap with a negative number

    init(type: MuBorderType,
         count: Int = 1,
         axis: Axis = .vertical) {
        
        self.type = type
        self.count = CGFloat(count)
        self.axis = axis
    }
    
    init(from: MuBorder) {
        self.type     = from.type
        self.margin   = from.margin
        self.axis     = from.axis
        self.count    = from.count
        self.diameter = from.diameter
        self.spacing  = Layout.spacing
    }

    func bounds(_ center: CGPoint) -> CGRect {
        let bounds = CGRect(x: center.x - diameter/2,
                            y: center.y - diameter/2,
                            width: diameter,
                            height: diameter)
        return bounds
    }
}

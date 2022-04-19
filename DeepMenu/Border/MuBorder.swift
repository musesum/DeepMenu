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
    lazy var thumbRadius = cornerRadius-1
    lazy var thumbRange = thumbRadius ... diameter-thumbRadius
    lazy var thumbRunway = diameter - thumbRadius*2
    lazy var vert = (axis == .vertical)
    lazy var length = (diameter + 2 * spacing)
    var runway: CGFloat { get { length * count + margin * 2 * (count-1) }}
    var width: CGFloat { get { vert ? length : runway }}

    var height: CGFloat {
        get {
            // add room for title for rectxy leaf
            type == .rect ? runway + Layout.titleHeight
            : vert ? runway : length
        }
    }

    var margin = CGFloat(0) // overlap with a negative number

    func normalizeTouch(xy: CGPoint) -> CGPoint {
        let xx = xy.x.clamped(to: thumbRange)
        let yy = xy.y.clamped(to: thumbRange)
        let xxx = (xx-thumbRadius) / thumbRunway
        let yyy = (yy-thumbRadius) / thumbRunway
        return CGPoint(x: xxx, y: yyy)
    }
    func expandNormalized(xy: CGPoint) -> CGSize {
        return CGSize(width:  xy.x * thumbRunway,
                      height: xy.y * thumbRunway)
    }

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

    func updateBounds(_ bounds: CGRect) -> CGRect {
        var result = bounds
        if vert {
            if bounds.minY < 0 {
                margin = bounds.minY/max(count,1)
                result.size.height += bounds.minY
                result.origin.y = 0
            }
        } else {
            if bounds.minX < 0 {
                margin = bounds.minX/max(count,1)
                result.size.width += bounds.minX
                result.origin.x = 0
            }
        }
        return result
    }

    func bounds(_ center: CGPoint) -> CGRect {

        return CGRect(x: center.x - diameter/2,
                      y: center.y - diameter/2,
                      width: diameter,
                      height: diameter)
    }
}

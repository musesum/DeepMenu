//  Created by warren on 12/20/21.

import SwiftUI

class MuBorder {
    var type: MuNodeType
    var axis: Axis
    var count: CGFloat

    // changed by type
    var diameter: CGFloat { get { Layout.diameter * (type.isLeaf ? 4 : 1) } }
    var cornerRadius: CGFloat { get { type.isLeaf ? (Layout.diameter + Layout.spacing) / 2 : (Layout.diameter / 2) }}

    var thumbRadius: CGFloat { get { Layout.diameter/2 - 1 } }
    var thumbValue : ClosedRange<CGFloat> { get { thumbRadius ... diameter-thumbRadius }}
    var thumbRunway: CGFloat { get { diameter - thumbRadius*2 }}

     var size: CGSize {
        get {
            let length = diameter + 2 * Layout.spacing
            let runway = length * count + margin * 2 * (count-1)
            let width = (axis == .vertical) ? length : runway
            let height = type.isLeaf ? runway + Layout.titleHeight : (axis == .vertical) ? runway : length
            return CGSize(width: width, height: height)
        }
    }

    var margin = CGFloat(0) // overlap with a negative number

    func normalizeTouch(xy: CGPoint) -> CGPoint {
        let xx = xy.x.clamped(to: thumbValue)
        let yy = xy.y.clamped(to: thumbValue)
        let xxx = (xx-thumbRadius) / thumbRunway
        let yyy = (yy-thumbRadius) / thumbRunway
        return CGPoint(x: xxx, y: yyy)
    }
    
    init(type: MuNodeType,
         count: Int = 1,
         axis: Axis = .vertical) {
        
        self.type = type
        self.count = CGFloat(count)
        self.axis = axis
    }
    
    init(from: MuBorder) {
        self.type   = from.type
        self.margin = from.margin
        self.axis   = from.axis
        self.count  = from.count
    }

    func updateBounds(_ bounds: CGRect) -> CGRect {
        var result = bounds
        if (axis == .vertical) {
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

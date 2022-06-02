//  Created by warren on 12/20/21.

import SwiftUI

class MuPanelVm {
    var type: MuNodeType
    var axis: Axis
    var count: CGFloat
    var margin = CGFloat(0) // overlap with a negative number

    // changed by type
    var cornerRadius: CGFloat { get {
        type.isLeaf
        ? (Layout.diameter + Layout.spacing) / 2
        : (Layout.diameter / 2)
    }}

    var thumbRadius = Layout.diameter/2 - 1
    func xRunway() -> CGFloat { return inner.width  - thumbRadius*2 }
    func yRunway() -> CGFloat { return inner.height - thumbRadius*2 }

    var aspect: CGSize { get {
        switch type {
            case .none : return CGSize(width: 1.0, height: 1.0)
            case .node : return CGSize(width: 1.0, height: 1.0)
            case .val  : return CGSize(width: 1.0, height: 4.0)
            case .vxy  : return CGSize(width: 4.0, height: 4.0)
            case .tog  : return CGSize(width: 1.5, height: 1.0)
            case .seg  : return CGSize(width: 1.0, height: 4.0)
            case .tap  : return CGSize(width: 1.5, height: 1.5)
        }
    }}
    var inner: CGSize {
        get {
            let result = aspect * Layout.diameter
            return result
        }}

    var outer: CGSize {
        get {
            let result: CGSize
            if type.isLeaf {
                result = inner + CGSize(width: 0, height: Layout.titleHeight)
            } else {
                let trough = Layout.diameter + (2 * Layout.spacing)
                let runway = (trough * count) + (margin * 2 * (count-1))
                let width  = (axis == .vertical ? trough : runway)
                let height = (axis == .vertical ? runway : trough)
                result = CGSize(width: width, height: height)
            }

            return result
        }
    }

    func normalizeTouch(xy: CGPoint) -> CGPoint {
        let xMax = (inner.width  - thumbRadius)
        let yMax = (inner.height - thumbRadius)
        let xRange = thumbRadius...xMax
        let yRange = thumbRadius...yMax
        let xx = xy.x.clamped(to: xRange)
        let yy = xy.y.clamped(to: yRange)
        let xxx = (xx - thumbRadius) / xRunway()
        let yyy = (yy - thumbRadius) / yRunway()
        let result = CGPoint(x: xxx, y: yyy)
        return result
    }
    func normalizeTouch(v: CGFloat) -> CGFloat {
        if axis == .vertical {
            let yMax = (inner.height - thumbRadius)
            let yRange = thumbRadius...yMax
            let yy = v.clamped(to: yRange)
            let yyy = (yy - thumbRadius) / yRunway()
            let result = CGFloat(yyy)
            return result
        } else {
            let xMax = (inner.width  - thumbRadius)
            let xRange = thumbRadius...xMax
            let xx = v.clamped(to: xRange)
            let xxx = (xx - thumbRadius) / xRunway()
            let result = CGFloat(xxx)
            return result
        }
    }
    init(type: MuNodeType,
         count: Int = 1,
         axis: Axis = .vertical) {
        
        self.type = type
        self.count = CGFloat(max(count,1))
        self.axis = axis
    }
    
    init(from: MuPanelVm) {
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
        let result = CGRect(x: center.x - outer.width/2,
                            y: center.y - outer.height/2,
                            width: outer.width,
                            height: outer.height)
        // log("cob ",  [center, outer, result])
        return result
    }
}

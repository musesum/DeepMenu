//  Created by warren on 12/20/21.

import SwiftUI

class MuPanelVm {
 
    var nodeType: MuNodeType
    var axis: Axis
    var corner: MuCorner
    var count: CGFloat
    var spacing = CGFloat(0) /// overlap with a negative number
    var aspectSz = CGSize(width: 1, height: 1) /// multiplier aspect ratio

    init(nodeType: MuNodeType,
         count: Int = 1,
         treeVm: MuTreeVm) {

        self.nodeType = nodeType
        self.count = CGFloat(max(count,1))
        self.axis = treeVm.axis
        self.corner = treeVm.corner
        setAspectFromType()
    }

    init(from: MuPanelVm) {
        self.nodeType = from.nodeType
        self.spacing = from.spacing
        self.axis    = from.axis
        self.corner  = from.corner
        self.count   = from.count
        setAspectFromType()
    }

    func setAspectFromType() {

        func aspect(_ lo: CGFloat,_ hi: CGFloat) {
            aspectSz = axis == .vertical
            ? CGSize(width: lo, height: hi)
            : CGSize(width: hi, height: lo)
        }

        switch nodeType {
            case .none : aspect(1.0, 1.0)
            case .node : aspect(1.0, 1.0)
            case .val  : aspect(1.0, 4.0)
            case .vxy  : aspect(4.0, 4.0)
            case .tog  : aspect(1.0, 1.5)
            case .seg  : aspect(1.0, 4.0)
            case .tap  : aspect(1.25, 1.25)
        }
    }

    // changed by type
    lazy var cornerRadius  : CGFloat = { (Layout.radius + Layout.padding) }()
    lazy var thumbRadius   : CGFloat = { Layout.radius - 1 }()
    lazy var thumbDiameter : CGFloat = { thumbRadius * 2 }()

    var runway: CGFloat {
        let result = axis == .vertical
        ? inner.height - thumbDiameter
        : inner.width - thumbDiameter
        return result
    }

    lazy var runwayXY: CGPoint = {
        CGPoint(x: inner.height - thumbDiameter,
                y: inner.width - thumbDiameter)
    }()

    var inner: CGSize {
        let result = aspectSz * Layout.diameter
        return result
    }

    var outer: CGSize {

        let result: CGSize
        let padpad = Layout.padding * 2
        let outerDiameter = Layout.diameter + padpad

        switch nodeType {

            case .val, .seg, .tog, .tap:

                result = inner + (
                    axis == .vertical
                    ? CGSize(width: padpad, height: outerDiameter)
                    : CGSize(width: outerDiameter, height: padpad))

            case .vxy: // header is always on top

                result = inner + CGSize(width: padpad, height: outerDiameter)

            case .none, .node:

                let longer = (outerDiameter + spacing) * count
                let width  = (axis == .vertical ? outerDiameter : longer)
                let height = (axis == .vertical ? longer : outerDiameter)

                result = CGSize(width: width, height: height)
        }
        return result
    }
    var titleSize: CGSize {
        switch nodeType {
            case .vxy: // title is always on top
                return CGSize(width:  inner.width,
                              height: Layout.diameter - 8)
           default:
                return CGSize(width:  Layout.diameter - 8,
                              height: Layout.diameter - 8)
        }
    }

    var innerOffset: CGSize {
        if nodeType == .vxy || axis == .vertical {
            return CGSize(width: Layout.padding,
                          height: titleSize.height+Layout.padding*2)
        }
        if corner.contains(.left) {
            return CGSize(width: Layout.padding*2,
                          height: Layout.padding*2)
        } else {
            return CGSize(width: titleSize.width,
                          height: Layout.padding)
        }
    }

    func normalizeTouch(xy: CGPoint) -> CGPoint {
        let xMax = (inner.width  - thumbRadius)
        let yMax = (inner.height - thumbRadius)
        let xRange = thumbRadius...xMax
        let yRange = thumbRadius...yMax
        let xClamp = xy.x.clamped(to: xRange)
        let yClamp = xy.y.clamped(to: yRange)
        let xNormal = (xClamp - thumbRadius) / runway
        let yNormal = (yClamp - thumbRadius) / runway
        let result = CGPoint(x: xNormal, y: (1-yNormal))
        return result
    }

    /// convert touch coordinates to 0...1
    func normalizeTouch(v: CGFloat) -> CGFloat {
        if axis == .vertical {
            let yMax = (inner.height - thumbRadius)
            let yClamp = v.clamped(to: thumbRadius...yMax)
            let yNormal = (yClamp - thumbRadius) / runway
            let result = CGFloat(yNormal)
            return 1 - result // invert so that 0 is on bottom
        } else {
            let xMax = (inner.width  - thumbRadius)
            let xClamp = v.clamped(to: thumbRadius...xMax)
            let xNormal = (xClamp - thumbRadius) / runway
            let result = CGFloat(xNormal)
            return result
        }
    }

    func updateBounds(_ bounds: CGRect) -> CGRect {
        var result = bounds
        if (axis == .vertical) {
            if bounds.minY < 0 {
                spacing = bounds.minY/max(count,1)
                result.size.height += bounds.minY
                result.origin.y = 0
            }
        } else {
            if bounds.minX < 0 {
                spacing = bounds.minX/max(count,1)
                result.size.width += bounds.minX
                result.origin.x = 0
            }
        }
        return result
    }

    func getBounds(from center: CGPoint) -> CGRect {
        let result = CGRect(x: center.x - outer.width/2,
                            y: center.y - outer.height/2,
                            width: outer.width,
                            height: outer.height)
        return result
    }
}

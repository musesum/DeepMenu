//
//  value+ext.swift
//  DeepMenu
//
//  Created by warren on 1/13/22.
//

import Foundation

extension ClosedRange {
    public func string(_ format: String = "(%.0f…%.0f %.0f…%.0f)") -> String {
        return String(format: format,
                      lowerBound as! CVarArg,
                      upperBound as? CVarArg ?? 9999)
    }

}

func scale(_ value: Float, fr: ClosedRange<Float>, to: ClosedRange<Float>) -> Float {
    let val = Float(value)
    
    let toSpan = to.upperBound - to.lowerBound // to
    let frSpan = fr.upperBound - fr.lowerBound // from
    let from01 = (val.clamped(to: fr) - fr.lowerBound) / frSpan
    let scaled = (from01 * toSpan) + to.lowerBound
    return scaled
}

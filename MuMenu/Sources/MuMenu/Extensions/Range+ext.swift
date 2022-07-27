//
//  value+ext.swift
//  DeepMenu
//
//  Created by warren on 1/13/22.
//

import Foundation

extension ClosedRange {
    public func string(_ format: String = "(%.0f…%.0f %.0f…%.0f)") -> String {
        String(format: format,
               lowerBound as! CVarArg,
               upperBound as? CVarArg ?? 9999)
    }

}

func scale(_ value: Float,
           from: ClosedRange<Float>,
           to: ClosedRange<Float>,
           invert: Bool = false) -> Float {

    let val = Float(value)
    
    let toSpan = to.upperBound - to.lowerBound // to
    let frSpan = from.upperBound - from.lowerBound // from
    let from01 = (val.clamped(to: from) - from.lowerBound) / frSpan
    let scaled = (from01 * toSpan) + to.lowerBound

    return invert ? 1-scaled : scaled
}

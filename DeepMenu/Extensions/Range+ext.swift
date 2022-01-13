//
//  Range+ext.swift
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

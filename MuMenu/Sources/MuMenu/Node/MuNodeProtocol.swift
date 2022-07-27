//  Created by warren on 6/9/22.

import SwiftUI
import Par // Visitor

/// exchange values with outside model
///
/// *Anys superlative is needed for CGPoint and other multidimensional controls.
/// Should synchronize set and get of multiple values to avoid jitter
///
public protocol MuNodeProtocol {

    /// set single named value
    func setAny(named: String,_ any: Any)

    /// set multiple named values
    func setAnys(_ anys: [(String, Any)])

    /// get single named value
    func getAny(named: String) -> Any?

    /// get multiple named values
    func getAnys(named: [String]) -> [(String, Any?)]

    /// get single named range
    func getRange(named: String) -> ClosedRange<Float>

    /// get multiple named ranges
    func getRanges(named: [String]) -> [(String, ClosedRange<Float>)]

    /// callback from outside sizer
    ///
    ///     - parameters:
    ///         - any: the calling class
    ///         - visitor: break visit loops
    func getting(_ any: Any, _ visitor: Visitor)
}

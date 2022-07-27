//
//  Set+ext.swift
//  DeepMenu
//
//  Created by warren on 7/10/22.
//

import Foundation


extension Set {

    func hasAny(_ other: Self) -> Bool {

        let result = self.intersection(other).count > 0
        return result
    }
}

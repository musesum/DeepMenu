//  Created by warren on 6/9/22.

import SwiftUI

public protocol MuLeafProtocol {
    func touchPoint(_ point: CGPoint) /// update from user interaction
    func updatePoint(_ point: CGPoint) /// update from model
}

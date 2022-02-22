// Created by warren 10/29/21.

import Foundation

import SwiftUI

class AppSpace: ObservableObject {
    @Published var backgroundColor = Color(red: 0.2, green: 0.0, blue: 0.0, opacity: 1.00)
    @Published var borderColor = Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 1.00)
    @Published var borderWidth = 2.0
    init() {}
}

/// placeholder dark red background
struct AppBackgroundView: View {

    @ObservedObject var space: AppSpace

    var body: some View {
        Rectangle()
            .foregroundColor(space.backgroundColor)
            .border(space.borderColor, width: space.borderWidth)
            .ignoresSafeArea(.all, edges: .all)
            .allowsHitTesting(false)
    }
}

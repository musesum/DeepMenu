// Created by warren 10/29/21.

import Foundation

import SwiftUI

class AppSpace: ObservableObject {
    @Published var backgroundColor = Color(red: 0.2, green: 0.0, blue: 0.0, opacity: 1.00)
    init() {}
}

/// placeholder dark red background
struct AppBackgroundView: View {

    @ObservedObject var space: AppSpace

    var body: some View {
        Rectangle()
            .foregroundColor(space.backgroundColor)
            .ignoresSafeArea(.all, edges: .all)
            .allowsHitTesting(false)
    }
}

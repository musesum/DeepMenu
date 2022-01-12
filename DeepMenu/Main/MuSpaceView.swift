// Created by warren 10/29/21.

import Foundation

import SwiftUI

class MuSpace: ObservableObject {
    @Published var color = Color(red: 1.0, green: 0.0, blue: 0.0, opacity: 0.20)
    init() {}
}

/// placeholder dark red background
struct MuSpaceView: View {

    @ObservedObject var space: MuSpace

    var body: some View {
        Rectangle()
            .foregroundColor(space.color)
            .ignoresSafeArea(.all, edges: .all)
            .allowsHitTesting(false)
    }
}

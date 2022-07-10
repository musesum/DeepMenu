// Created by warren 10/29/21.

import Foundation

import SwiftUI

class CanvasVm: ObservableObject {
    static let shared = CanvasVm() //TODO: Unused
    @Published var color = Color(red: 0.2, green: 0.0, blue: 0.0, opacity: 1.00)
    init() {}
    var bounds = CGRect.zero
    func updateBounds(_ bounds: CGRect) {
        self.bounds = bounds //TODO: unused
        log("CanvasVm",[bounds])
    }
}


/// placeholder dark red background
struct CanvasView: View {

    let canvasVm = CanvasVm.shared
    var body: some View {
        GeometryReader { geo in
            Rectangle()
                .foregroundColor(canvasVm.color)
                .ignoresSafeArea(.all, edges: .all)
                .allowsHitTesting(false)
                .onAppear { canvasVm.updateBounds(geo.frame(in: .named("Canvas"))) }
                .onChange(of: geo.frame(in: .named("Canvas"))) { canvasVm.updateBounds($0) }
                .environmentObject(canvasVm)

        }
    }
}

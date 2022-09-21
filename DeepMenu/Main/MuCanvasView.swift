// Created by warren 10/29/21.

import Foundation

import SwiftUI
import MuMenu

class MuCanvasVm: ObservableObject {
    static let shared = MuCanvasVm()
    @Published var color = Color(red: 0.2, green: 0.0, blue: 0.0, opacity: 1.00)
    init() {}
    var bounds = CGRect.zero
    func updateBounds(_ bounds: CGRect) {
        self.bounds = bounds //TODO: unused
        log("CanvasVm",[bounds])
    }

    public func touchUpdate(_ touchNow: CGPoint) {
        log("canvas", [touchNow], terminator: " ")
    }
}


struct MuCanvasView: View {
    @GestureState private var touchXY: CGPoint = .zero
    let canvasVm = MuCanvasVm.shared
    
    var body: some View {
        let drag = DragGesture(minimumDistance: 0,
                               coordinateSpace: .named("Canvas"))
            .updating($touchXY) { (value, touchXY, _) in touchXY = value.location }

        GeometryReader { geo in
            Rectangle()
                //??? .foregroundColor(canvasVm.color)
                .ignoresSafeArea(.all, edges: .all)
                .allowsHitTesting(true)
                .onAppear { canvasVm.updateBounds(geo.frame(in: .named("Canvas"))) }
                .onChange(of: geo.frame(in: .named("Canvas"))) { canvasVm.updateBounds($0) }
                //?? .environmentObject(canvasVm)
                .coordinateSpace(name: "Canvas")
                .gesture(drag)
                .onChange(of: touchXY) { canvasVm.touchUpdate($0) }
            

        }
    }
}

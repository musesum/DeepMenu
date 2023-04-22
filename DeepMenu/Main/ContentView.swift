// Created 9/26/21.
import UIKit
import SwiftUI
import MuMenu
import MuMenuSky
import MuSkyFlo

struct ContentView: View {

    var body: some View {

        let rootFlo = TestSkyFlo.shared.root
        let rootNode = MuFloNode(rootFlo)
        let leftVm  = MenuVm([.lower, .left],  [(rootNode, .vertical),
                                                (rootNode, .horizontal)])

        ZStack(alignment: .bottomLeading) {
            Rectangle()
                .foregroundColor(.init(uiColor: .black))
                .ignoresSafeArea(.all, edges: .all)

            // to add UIKit touch handler, will need a ViewController
            // TouchRepresentable([leftVm.rootVm.touchVm, rightVm.rootVm.touchVm])
            // Menus without drag
            MenuDragView(menuVm: leftVm)
            //MenuDragView(menuVm: rightVm)
        }
        .statusBar(hidden: true)
    }
}

struct TouchRepresentable: UIViewRepresentable {

    typealias Context = UIViewRepresentableContext<TouchRepresentable>
    var touchVms: [MuTouchVm]
    var touchView = TouchView() 

    init(_ touchVms: [MuTouchVm]) {
        self.touchVms = touchVms
        for touchVm in touchVms {
            CornerTouchVm[touchVm.corner.rawValue] = touchVm
        }
    }
    public func makeUIView(context: Context) -> TouchView {
        return touchView
    }
    public func updateUIView(_ uiView: TouchView, context: Context) {
        print("🔶", terminator: " ")
    }
}

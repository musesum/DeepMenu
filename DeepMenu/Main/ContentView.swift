// Created 9/26/21.
import UIKit
import SwiftUI
import MuMenu
import MuMenuSky
import MuSkyTr3

struct ContentView: View {

    var body: some View {

        let rootTr3 = TestSkyTr3.shared.root
        let rootNode = MuTr3Node(rootTr3)
        let leftVm  = MenuSkyVm([.lower, .left],  [(rootNode, .vertical),
                                                   (rootNode, .horizontal)])
        //let rightVm = MenuSkyVm([.lower, .left], [(rootNode, .vertical)])
        

        ZStack(alignment: .bottomLeading) {
            Rectangle()
                .foregroundColor(.init(uiColor: .darkGray))
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
    var touchView = TouchView.shared

    init(_ touchVms: [MuTouchVm]) {
        self.touchVms = touchVms
        TouchMenu.touchVms.append(contentsOf: touchVms)
    }
    public func makeUIView(context: Context) -> TouchView {
        return touchView
    }
    public func updateUIView(_ uiView: TouchView, context: Context) {
        print("🔶", terminator: " ")
    }
}

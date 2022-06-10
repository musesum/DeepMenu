// Created 9/26/21.

import SwiftUI

/**
 ContentView.main is only used to remove annoying `taskbar`
 by adding HostingController to AppPortDelegates
    - note: TODO: remove this if Apple fixes
 */
struct ContentViews {
    static let main = ContentView()
    static let client = ExampleClientView()
}


struct ContentView: View {
    
    @EnvironmentObject var rootVm: MuRootVm
    @GestureState private var touchXY: CGPoint = .zero
    let appSpace = AppSpace()
    let contentVm = ContentVm()
    

    var body: some View {
        // ContentViews.client
        ZStack(alignment: .bottomLeading) {
            AppBackgroundView(space: appSpace)
            MuRootView().environmentObject(contentVm.testRootVm)
            //MuRootView().environmentObject(contentVm.skyRootVm)
        }
        .coordinateSpace(name: "Sky")
        .statusBar(hidden: true)
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .named("Sky"))
            .updating($touchXY) { (value, touchXY, _) in touchXY = value.location })
        .onChange(of: touchXY) { contentVm.testRootVm.touchVm.touchUpdate($0) }

    }
}

#if false
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView.shared
            .environment(\.colorScheme, .dark)
    }
}
#endif


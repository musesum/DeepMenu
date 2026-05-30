import SwiftUI
import MuPeers

@main
struct DeepWatchApp: App {
    init() {
        // Touch Peers.shared so the listener + browser start advertising
        // on _deepmuse-peer._tcp at app launch. Watch joins the mesh and
        // broadcasts MenuItem updates the same way iOS/iPad peers do.
        _ = Peers.shared
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

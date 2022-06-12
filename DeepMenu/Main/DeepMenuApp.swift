import SwiftUI

@main
struct app: App {
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                PathView()
            }
        }
    }
}

import SwiftUI

@main
struct app: App {
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentViews.main
                ContentViews.client
            }
        }
    }
}

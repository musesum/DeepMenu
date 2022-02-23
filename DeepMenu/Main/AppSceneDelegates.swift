
//  AppSceneDelegates.swift

import SwiftUI

/**
 Setup `SceneDelegate` to use `HostingController` to remove annoying taskbar.
*/
class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        let config = UISceneConfiguration(name: "MainScene", sessionRole: .windowApplication)
        config.delegateClass = SceneDelegate.self
        return config
    }
}

/**
 Even though this was elimiated for iOS 15, a SceneDelegate is still needed to remove the annoying taskbar. Side effect is that the `ContentView` is referenced twice, so use a singleton `ContentView.shared`
 */
class SceneDelegate: NSObject, UIWindowSceneDelegate, ObservableObject {
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        /// setup `HostingController` here:
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let rootView = ContentViews.main
            let hostingController = HostingController(rootView: rootView)
            window.rootViewController = hostingController
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
/**
  remove annoying taskbar via `prefersHomeIndicatorAutoHidden`
 */
class HostingController: UIHostingController<ContentView> {
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
}

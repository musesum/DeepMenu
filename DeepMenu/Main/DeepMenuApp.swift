import SwiftUI
import MuMenu

#if os(visionOS)
import ARKit
import CompositorServices
import MuVision

@main
struct app: App {
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView.shared
                PathView()
            }
        }
        ImmersiveSpace(id: "ImmersiveSpace") {
            CompositorLayer(configuration: MetalLayerConfiguration()) { layerRenderer in
                let renderer = RenderLayer(layerRenderer)
                renderer.startRenderLoop()
            }
        }.immersionStyle(selection: .constant(.automatic), in: .full)
    }
    struct MetalLayerConfiguration: CompositorLayerConfiguration {
        func makeConfiguration(capabilities: LayerRenderer.Capabilities,
                               configuration: inout LayerRenderer.Configuration)
        {
            let supportsFoveation = capabilities.supportsFoveation
            configuration.layout = .dedicated
            configuration.isFoveationEnabled = supportsFoveation
            configuration.colorFormat = .rgba16Float
        }
    }
}
#else

@main
struct app: App {
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView.shared
                PathView()
            }
        }
    }
}
#endif

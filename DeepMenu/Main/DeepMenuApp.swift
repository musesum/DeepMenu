import SwiftUI
import MuMenu

#if os(visionOS)
import ARKit
import CompositorServices
import MuVision
#endif

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
#if os(visionOS)
        ImmersiveSpace(id: "ImmersiveSpace") {
            CompositorLayer(configuration: MetalLayerConfiguration()) { layerRenderer in
                let renderer = RenderLayer(layerRenderer)
                renderer.startRenderLoop()
            }
        }.immersionStyle(selection: .constant(.automatic), in: .full)
#endif
    }
}
#if os(visionOS)
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

#endif

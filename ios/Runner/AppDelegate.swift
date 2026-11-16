import Flutter
import GoogleMaps
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // The key comes from ios/Flutter/Secrets.xcconfig via Info.plist.
    // Without one the map still opens, but shows no tiles.
    let mapsApiKey = Bundle.main.object(forInfoDictionaryKey: "MapsApiKey") as? String ?? ""
    #if targetEnvironment(simulator)
      // The Metal map renderer draws a black map on Intel-Mac simulators.
      // Real devices keep the default (Metal) renderer.
      GMSServices.setMetalRendererEnabled(false)
    #endif
    GMSServices.provideAPIKey(mapsApiKey.isEmpty ? "MISSING_MAPS_API_KEY" : mapsApiKey)

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

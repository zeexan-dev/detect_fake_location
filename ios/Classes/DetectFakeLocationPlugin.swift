import Flutter
import UIKit
import CoreLocation

public class DetectFakeLocationPlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "detect_fake_location", binaryMessenger: registrar.messenger())
        let instance = DetectFakeLocationPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

        if call.method == "detectFakeLocation" {

            // Extract configuration parameters from the method call
            let arguments = call.arguments as? [String: Any]
            let ignoreExternalAccessory = arguments?["ignoreExternalAccessory"] as? Bool ?? false

            let locationManager = CLLocationManager()

            if #available(iOS 15.0, *) {
                // Safe on iOS 15+
                if let sourceInfo = locationManager.location?.sourceInformation {
                    var isFakeLocation = false

                    // Check if simulated by software
                    if sourceInfo.isSimulatedBySoftware {
                        isFakeLocation = true
                    }

                    // Check if produced by external accessory, only if not ignored
                    if !ignoreExternalAccessory && sourceInfo.isProducedByAccessory {
                        isFakeLocation = true
                    }

                    result(isFakeLocation)
                    return
                }
            }

            // Fallback for iOS <15 or when location/sourceInformation is nil
            result(false)
        }
    }
}

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

        if call.method == "detectFakeLocation"{

            // Extract configuration parameters from the method call
            let arguments = call.arguments as? [String: Any]
            let ignoreExternalAccessory = arguments?["ignoreExternalAccessory"] as? Bool ?? false

            let locationManager = CLLocationManager()
            if #available(iOS 15.0, *) {
                // use UICollectionViewCompositionalLayout
                let isLocationSimulated = locationManager.location?.sourceInformation?.isSimulatedBySoftware ?? false
                let isProducedByAccess = locationManager.location?.sourceInformation?.isProducedByAccessory ?? false

                let info = CLLocationSourceInformation(softwareSimulationState: isLocationSimulated, andExternalAccessoryState: isProducedByAccess)

                // Check for fake location based on configuration
                var isFakeLocation = false

                // Always check for software simulation
                if info.isSimulatedBySoftware == true {
                    isFakeLocation = true
                }

                // Conditionally check for external accessory based on configuration
                if !ignoreExternalAccessory && info.isProducedByAccessory == true {
                    isFakeLocation = true
                }

                result(isFakeLocation)
            }
            else{
                result(false)
            }

        }
    }
}

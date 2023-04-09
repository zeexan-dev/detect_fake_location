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
            
            let locationManager = CLLocationManager()
            if #available(iOS 15.0, *) {
                // use UICollectionViewCompositionalLayout
                let isLocationSimulated = locationManager.location?.sourceInformation?.isSimulatedBySoftware ?? false
                let isProducedByAccess = locationManager.location?.sourceInformation?.isProducedByAccessory ?? false
                
                let info = CLLocationSourceInformation(softwareSimulationState: isLocationSimulated, andExternalAccessoryState: isProducedByAccess)
                
                if info.isSimulatedBySoftware == true || info.isProducedByAccessory == true{
                    result(true)
                } else {
                    result(false)
                }
            }
            else{
                result(false)
            }
            
        }
    }
}

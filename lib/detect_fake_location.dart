// import 'detect_fake_location_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class DetectFakeLocation {
  static const mothodChannel = MethodChannel('detect_fake_location');

  Future<bool> detectFakeLocation({bool ignoreExternalAccessory = false}) async {
    bool result = false;
    if (await Permission.location.isGranted) {
      result = await mothodChannel.invokeMethod('detectFakeLocation', {
        'ignoreExternalAccessory': ignoreExternalAccessory,
      });
      return result;
    } else {
      PermissionStatus status = await Permission.locationWhenInUse.request();
      if (status == PermissionStatus.granted) {
        result = await mothodChannel.invokeMethod('detectFakeLocation', {
          'ignoreExternalAccessory': ignoreExternalAccessory,
        });
        return result;
      } else if (status == PermissionStatus.permanentlyDenied) {
        return false;
      } else {
        return false;
      }
    }
  }
}

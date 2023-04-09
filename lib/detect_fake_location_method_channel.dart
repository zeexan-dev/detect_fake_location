import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'detect_fake_location_platform_interface.dart';

/// An implementation of [DetectFakeLocationPlatform] that uses method channels.
class MethodChannelDetectFakeLocation extends DetectFakeLocationPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('detect_fake_location');

  @override
  Future<bool?> detectFakeLocation() async {
    final version =
        await methodChannel.invokeMethod<bool>('detectFakeLocation');
    return version;
  }
}

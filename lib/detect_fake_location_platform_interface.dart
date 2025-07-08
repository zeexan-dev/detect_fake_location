import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'detect_fake_location_method_channel.dart';

abstract class DetectFakeLocationPlatform extends PlatformInterface {
  /// Constructs a DetectFakeLocationPlatform.
  DetectFakeLocationPlatform() : super(token: _token);

  static final Object _token = Object();

  static DetectFakeLocationPlatform _instance =
  MethodChannelDetectFakeLocation();

  /// The default instance of [DetectFakeLocationPlatform] to use.
  ///
  /// Defaults to [MethodChannelDetectFakeLocation].
  static DetectFakeLocationPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DetectFakeLocationPlatform] when
  /// they register themselves.
  static set instance(DetectFakeLocationPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool?> detectFakeLocation({bool ignoreExternalAccessory = false}) {
    throw UnimplementedError('detectFakeLocation() has not been implemented.');
  }
}

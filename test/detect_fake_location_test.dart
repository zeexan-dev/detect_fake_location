import 'package:flutter_test/flutter_test.dart';
import 'package:detect_fake_location/detect_fake_location.dart';
import 'package:detect_fake_location/detect_fake_location_platform_interface.dart';
import 'package:detect_fake_location/detect_fake_location_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDetectFakeLocationPlatform
    with MockPlatformInterfaceMixin
    implements DetectFakeLocationPlatform {
  @override
  Future<bool?> detectFakeLocation() => Future.value(false);
}

void main() {
  final DetectFakeLocationPlatform initialPlatform =
      DetectFakeLocationPlatform.instance;

  test('$MethodChannelDetectFakeLocation is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDetectFakeLocation>());
  });

  test('detectFakeLocation', () async {
    DetectFakeLocation detectFakeLocationPlugin = DetectFakeLocation();
    MockDetectFakeLocationPlatform fakePlatform =
        MockDetectFakeLocationPlatform();
    DetectFakeLocationPlatform.instance = fakePlatform;

    expect(await detectFakeLocationPlugin.detectFakeLocation(), false);
  });
}

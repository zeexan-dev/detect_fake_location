import 'package:flutter_test/flutter_test.dart';
import 'package:detect_fake_location/detect_fake_location_platform_interface.dart';
import 'package:detect_fake_location/detect_fake_location_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDetectFakeLocationPlatform
    with MockPlatformInterfaceMixin
    implements DetectFakeLocationPlatform {
  @override
  Future<bool?> detectFakeLocation({bool ignoreExternalAccessory = false}) =>
      Future.value(false);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final DetectFakeLocationPlatform initialPlatform =
      DetectFakeLocationPlatform.instance;

  test('$MethodChannelDetectFakeLocation is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDetectFakeLocation>());
  });

  test('detectFakeLocation with default parameters', () async {
    MockDetectFakeLocationPlatform fakePlatform =
        MockDetectFakeLocationPlatform();
    DetectFakeLocationPlatform.instance = fakePlatform;

    expect(await fakePlatform.detectFakeLocation(), false);
  });

  test('detectFakeLocation with ignoreExternalAccessory false', () async {
    MockDetectFakeLocationPlatform fakePlatform =
        MockDetectFakeLocationPlatform();
    DetectFakeLocationPlatform.instance = fakePlatform;

    expect(
        await fakePlatform.detectFakeLocation(ignoreExternalAccessory: false),
        false);
  });

  test('detectFakeLocation with ignoreExternalAccessory true', () async {
    MockDetectFakeLocationPlatform fakePlatform =
        MockDetectFakeLocationPlatform();
    DetectFakeLocationPlatform.instance = fakePlatform;

    expect(await fakePlatform.detectFakeLocation(ignoreExternalAccessory: true),
        false);
  });
}

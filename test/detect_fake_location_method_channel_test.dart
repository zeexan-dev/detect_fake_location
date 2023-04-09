import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:detect_fake_location/detect_fake_location_method_channel.dart';

void main() {
  MethodChannelDetectFakeLocation platform = MethodChannelDetectFakeLocation();
  const MethodChannel channel = MethodChannel('detect_fake_location');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return false;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('detectFakeLocation', () async {
    expect(await platform.detectFakeLocation(), false);
  });
}

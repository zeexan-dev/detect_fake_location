import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:detect_fake_location/detect_fake_location_method_channel.dart';

void main() {
  MethodChannelDetectFakeLocation platform = MethodChannelDetectFakeLocation();
  const MethodChannel channel = MethodChannel('detect_fake_location');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      // Verify that the method call includes the expected arguments
      if (methodCall.method == 'detectFakeLocation') {
        // Handle both null arguments (old API) and map arguments (new API)
        final arguments = methodCall.arguments;
        if (arguments == null || arguments is Map) {
          // Return false for all test cases
          return false;
        }
      }
      return false;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('detectFakeLocation with default parameters', () async {
    expect(await platform.detectFakeLocation(), false);
  });

  test('detectFakeLocation with ignoreExternalAccessory false', () async {
    expect(await platform.detectFakeLocation(ignoreExternalAccessory: false), false);
  });

  test('detectFakeLocation with ignoreExternalAccessory true', () async {
    expect(await platform.detectFakeLocation(ignoreExternalAccessory: true), false);
  });

  test('detectFakeLocation method call arguments', () async {
    bool methodCallReceived = false;
    Map<String, dynamic>? receivedArguments;

    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'detectFakeLocation') {
        methodCallReceived = true;
        // Safely cast the arguments
        if (methodCall.arguments is Map) {
          receivedArguments = Map<String, dynamic>.from(methodCall.arguments as Map);
        }
      }
      return false;
    });

    await platform.detectFakeLocation(ignoreExternalAccessory: true);

    expect(methodCallReceived, true);
    expect(receivedArguments?['ignoreExternalAccessory'], true);
  });
}

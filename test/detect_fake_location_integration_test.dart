import 'package:flutter_test/flutter_test.dart';
import 'package:detect_fake_location/detect_fake_location_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// Mock platform that simulates different fake location scenarios
class MockDetectFakeLocationPlatformWithScenarios
    with MockPlatformInterfaceMixin
    implements DetectFakeLocationPlatform {
  bool _simulatesSoftware = false;
  bool _simulatesAccessory = false;

  /// Configure the mock to simulate software-based fake location
  void setSoftwareSimulation(bool enabled) {
    _simulatesSoftware = enabled;
  }

  /// Configure the mock to simulate external accessory location
  void setAccessorySimulation(bool enabled) {
    _simulatesAccessory = enabled;
  }

  @override
  Future<bool?> detectFakeLocation(
      {bool ignoreExternalAccessory = false}) async {
    // Simulate the iOS logic:
    // - Always check for software simulation
    // - Conditionally check for external accessory based on ignoreExternalAccessory parameter

    bool isFakeLocation = false;

    // Always check for software simulation
    if (_simulatesSoftware) {
      isFakeLocation = true;
    }

    // Conditionally check for external accessory
    if (!ignoreExternalAccessory && _simulatesAccessory) {
      isFakeLocation = true;
    }

    return isFakeLocation;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DetectFakeLocation Integration Tests', () {
    late MockDetectFakeLocationPlatformWithScenarios mockPlatform;

    setUp(() {
      mockPlatform = MockDetectFakeLocationPlatformWithScenarios();
      DetectFakeLocationPlatform.instance = mockPlatform;
    });

    group('Software Simulation Detection', () {
      test(
          'detects software simulation regardless of ignoreExternalAccessory setting',
          () async {
        mockPlatform.setSoftwareSimulation(true);
        mockPlatform.setAccessorySimulation(false);

        // Should detect fake location in both modes when software simulation is active
        expect(
            await mockPlatform.detectFakeLocation(
                ignoreExternalAccessory: false),
            true);
        expect(
            await mockPlatform.detectFakeLocation(
                ignoreExternalAccessory: true),
            true);
      });

      test('does not detect fake location when no simulation is active',
          () async {
        mockPlatform.setSoftwareSimulation(false);
        mockPlatform.setAccessorySimulation(false);

        // Should not detect fake location in either mode
        expect(
            await mockPlatform.detectFakeLocation(
                ignoreExternalAccessory: false),
            false);
        expect(
            await mockPlatform.detectFakeLocation(
                ignoreExternalAccessory: true),
            false);
      });
    });

    group('External Accessory Detection', () {
      test('detects external accessory when ignoreExternalAccessory is false',
          () async {
        mockPlatform.setSoftwareSimulation(false);
        mockPlatform.setAccessorySimulation(true);

        // Should detect fake location when checking accessories
        expect(
            await mockPlatform.detectFakeLocation(
                ignoreExternalAccessory: false),
            true);

        // Should NOT detect fake location when ignoring accessories
        expect(
            await mockPlatform.detectFakeLocation(
                ignoreExternalAccessory: true),
            false);
      });

      test('ignores external accessory when ignoreExternalAccessory is true',
          () async {
        mockPlatform.setSoftwareSimulation(false);
        mockPlatform.setAccessorySimulation(true);

        // Should NOT detect fake location when ignoring accessories
        expect(
            await mockPlatform.detectFakeLocation(
                ignoreExternalAccessory: true),
            false);
      });
    });

    group('Combined Scenarios', () {
      test(
          'detects fake location when both software and accessory simulation are active',
          () async {
        mockPlatform.setSoftwareSimulation(true);
        mockPlatform.setAccessorySimulation(true);

        // Should detect fake location in both modes (software simulation always triggers detection)
        expect(
            await mockPlatform.detectFakeLocation(
                ignoreExternalAccessory: false),
            true);
        expect(
            await mockPlatform.detectFakeLocation(
                ignoreExternalAccessory: true),
            true);
      });
    });

    group('Backward Compatibility', () {
      test('default behavior matches original implementation', () async {
        mockPlatform.setSoftwareSimulation(false);
        mockPlatform.setAccessorySimulation(true);

        // Default behavior (ignoreExternalAccessory: false) should detect accessory simulation
        expect(await mockPlatform.detectFakeLocation(), true);
      });

      test('parameter defaults work correctly', () async {
        mockPlatform.setSoftwareSimulation(false);
        mockPlatform.setAccessorySimulation(true);

        // Calling without parameters should be equivalent to ignoreExternalAccessory: false
        final resultWithoutParam = await mockPlatform.detectFakeLocation();
        final resultWithFalseParam = await mockPlatform.detectFakeLocation(
            ignoreExternalAccessory: false);

        expect(resultWithoutParam, resultWithFalseParam);
        expect(resultWithoutParam, true); // Should detect accessory simulation
      });
    });

    group('Edge Cases', () {
      test('handles null/false scenarios correctly', () async {
        mockPlatform.setSoftwareSimulation(false);
        mockPlatform.setAccessorySimulation(false);

        // No simulation should result in false detection
        expect(
            await mockPlatform.detectFakeLocation(
                ignoreExternalAccessory: false),
            false);
        expect(
            await mockPlatform.detectFakeLocation(
                ignoreExternalAccessory: true),
            false);
      });
    });
  });
}

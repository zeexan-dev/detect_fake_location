# detect_fake_location

This is a Flutter plugin that detects if the user is using a fake(mock or simulated) location on their device.

[![Pub](https://img.shields.io/pub/v/detect_fake_location.svg)](https://pub.dev/packages/detect_fake_location)
[![License](https://img.shields.io/badge/licence-BSD3-blue.svg)](https://github.com/sarbagyastha/flutter_rating_bar/blob/master/LICENSE)
[![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/zeexan-dev/detect_fake_location.svg)](https://github.com/zeexan-dev/detect_fake_location)

## Installation

To use this plugin, add detect_fake_location as a dependency in your pubspec.yaml file.

## Permissions

### iOS
Add the following entries to your Info.plist file
```xml
<key>NSLocationAlwaysUsageDescription</key>
<string>App needs access to location when in the background.</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>App requires access to location when open.</string>
```
Add the following to your Podfile
```pod
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    # Start of the permission_handler configuration
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
      # dart: [PermissionGroup.location, PermissionGroup.locationAlways, PermissionGroup.locationWhenInUse]
        'PERMISSION_LOCATION=1'
    ]
    end
  end
end
```

### Android
Add the ACCESS_COARSE_LOCATION and ACCESS_FINE_LOCATION permission to your Android Manifest.
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

## Usage
Import the package with:

```dart
import 'package:detect_fake_location/detect_fake_location.dart';
```

Then you can use the following method to check if the user is using a fake location:

```dart
// Basic usage (default behavior)
bool isFakeLocation = await DetectFakeLocation().detectFakeLocation();

// Advanced usage with configuration options
bool isFakeLocation = await DetectFakeLocation().detectFakeLocation(
  ignoreExternalAccessory: true, // Ignore external accessories like CarPlay
);
```

## Configuration Options

### ignoreExternalAccessory (iOS only)

By default, the plugin detects fake locations from both software simulation and external accessories. However, external accessories like CarPlay, external GPS devices, or other legitimate hardware can trigger false positives.

- **Default:** `false` (maintains backward compatibility)
- **When to use `true`:** If you want to ignore location data from external accessories and only detect software-based fake locations
- **Use case:** Prevent false positives when users have legitimate external accessories connected

```dart
// Only detect software-simulated locations, ignore external accessories
bool isFakeLocation = await DetectFakeLocation().detectFakeLocation(
  ignoreExternalAccessory: true,
);
```

## Example
```dart
import 'package:flutter/material.dart';
import 'package:detect_fake_location/detect_fake_location.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Detect Fake Location (Standard)'),
              onPressed: () async {
                bool isFakeLocation =
                    await DetectFakeLocation().detectFakeLocation();
                _showResult(context, isFakeLocation, 'Standard Mode');
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Detect Fake Location (Ignore External Accessory)'),
              onPressed: () async {
                bool isFakeLocation = await DetectFakeLocation()
                    .detectFakeLocation(ignoreExternalAccessory: true);
                _showResult(context, isFakeLocation, 'Ignore External Accessory Mode');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showResult(BuildContext context, bool isFakeLocation, String mode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Fake Location Detection Result'),
          content: Text(
              'Mode: $mode\nThe user is${isFakeLocation ? '' : ' not'} using a fake location.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

```

![Image 1](https://user-images.githubusercontent.com/6541601/230794507-3ebf98ff-6cb5-4fae-b713-b1ab4e425308.PNG)
![Image 2](https://user-images.githubusercontent.com/6541601/230794510-159d7dbc-d762-45fc-8b08-6fcfb293a458.PNG)

## Limitations
For iOS, the plugin uses the CLLocationSourceInformation class to detect if the location is simulated by software or produced by an external accessory. This class is only available on iOS 15 or later.

## Contribute
Contributions are welcome! Please submit issues and pull requests on the GitHub repository.

## Credits
For requesting permissions:  [permission_handler](https://pub.dev/packages/permission_handler)

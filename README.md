# detect_fake_location

This is a Flutter plugin that detects if the user is using a fake(mock or simulated) location on their device.

## Installation

To use this plugin, add detect_fake_location as a dependency in your pubspec.yaml file.

## Permissions

### iOS
Add the following entries to your Info.plist file
```
<key>NSLocationAlwaysUsageDescription</key>
<string>App needs access to location when in the background.</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>App requires access to location when open.</string>
```
Add the following to your Podfile
```
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
Add the ACCESS_COARSE_LOCATION, ACCESS_FINE_LOCATION and ACCESS_MOCK_LOCATION permission to your Android Manifest.
```
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_MOCK_LOCATION" />
```

## Usage
Import the package with:

```
import 'package:detect_fake_location/detect_fake_location.dart';
```

Then you can use the following method to check if the user is using a fake location:

```
bool isFakeLocation = await DetectFakeLocation().detectFakeLocation();
```

## Example
```
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
        child: ElevatedButton(
          child: Text('Detect Fake Location'),
          onPressed: () async {
            bool isFakeLocation =
                await DetectFakeLocation().detectFakeLocation();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Fake Location Detected'),
                  content: Text(
                      'The user is${isFakeLocation ? '' : ' not'} using a fake location.'),
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
          },
        ),
      ),
    );
  }
}

```

![Image 1](https://user-images.githubusercontent.com/6541601/230794507-3ebf98ff-6cb5-4fae-b713-b1ab4e425308.PNG)
![Image 2](https://user-images.githubusercontent.com/6541601/230794510-159d7dbc-d762-45fc-8b08-6fcfb293a458.PNG)

## Limitations
For Android, the plugin uses the isMockLocationEnabled method to detect if the user is using a fake location. This method requires the ACCESS_MOCK_LOCATION permission, which may not be granted on some devices. In this case, the method will return false.

For iOS, the plugin uses the CLLocationSourceInformation class to detect if the location is simulated by software or produced by an external accessory. This class is only available on iOS 15 or later.

## Contribute
Contributions are welcome! Please submit issues and pull requests on the GitHub repository.

## Credits
For requesting permissions:  [permission_handler](https://pub.dev/packages/permission_handler)

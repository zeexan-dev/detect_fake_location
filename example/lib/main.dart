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

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _ignoreExternalAccessory = false;

  void _showResult(String title, bool isFakeLocation, String mode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fake Location Detection Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Configure Detection Settings',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 20),
            SwitchListTile(
              title: Text('Ignore External Accessory'),
              subtitle: Text(
                'When enabled, external accessories (like CarPlay) won\'t trigger fake location detection',
              ),
              value: _ignoreExternalAccessory,
              onChanged: (bool value) {
                setState(() {
                  _ignoreExternalAccessory = value;
                });
              },
            ),
            SizedBox(height: 30),
            ElevatedButton(
              child: Text('Detect Fake Location'),
              onPressed: () async {
                bool isFakeLocation = await DetectFakeLocation()
                    .detectFakeLocation(
                        ignoreExternalAccessory: _ignoreExternalAccessory);
                _showResult(
                  'Fake Location Detection Result',
                  isFakeLocation,
                  _ignoreExternalAccessory
                      ? 'Ignoring External Accessory'
                      : 'Checking All Sources',
                );
              },
            ),
            SizedBox(height: 20),
            Text(
              'Test Both Modes:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: Text('Standard Mode'),
                  onPressed: () async {
                    bool isFakeLocation = await DetectFakeLocation()
                        .detectFakeLocation(ignoreExternalAccessory: false);
                    _showResult(
                      'Standard Mode Result',
                      isFakeLocation,
                      'Checking All Sources',
                    );
                  },
                ),
                ElevatedButton(
                  child: Text('Ignore Accessory'),
                  onPressed: () async {
                    bool isFakeLocation = await DetectFakeLocation()
                        .detectFakeLocation(ignoreExternalAccessory: true);
                    _showResult(
                      'Ignore Accessory Mode Result',
                      isFakeLocation,
                      'Ignoring External Accessory',
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

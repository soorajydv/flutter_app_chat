import 'dart:io';

import 'package:flutter/material.dart';
import 'package:light_sensor/light_sensor.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shake/shake.dart';

class SensorChatApp extends StatefulWidget {
  @override
  _SensorChatAppState createState() => _SensorChatAppState();
}

class _SensorChatAppState extends State<SensorChatApp> {
  int _selectedIndex = 1;

  final List<Widget> _pages = [
    LightSensorThemePage(),
    ShakeSwapMessagesPage(),
    GyroEmojiReactionPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.light_mode), label: 'Theme'),
          BottomNavigationBarItem(
              icon: Icon(Icons.swap_horiz), label: 'Shake Swap'),
          BottomNavigationBarItem(
              icon: Icon(Icons.emoji_emotions), label: 'Gyro Emoji'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// 1. Light Sensor for Auto Theme Switching
class LightSensorThemePage extends StatefulWidget {
  @override
  _LightSensorThemePageState createState() => _LightSensorThemePageState();
}

class _LightSensorThemePageState extends State<LightSensorThemePage> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    initLightSensor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.black : Colors.white,
      body: Center(
        child: Text(
          _isDarkMode ? "Dark Mode Activated" : "Light Mode Activated",
          style: TextStyle(
              color: _isDarkMode ? Colors.white : Colors.black, fontSize: 20),
        ),
      ),
    );
  }

  void initLightSensor() async {
    if (Platform.isAndroid && await LightSensor.hasSensor()) {
      print('Have light sensor');
      LightSensor.luxStream().asBroadcastStream(
        onListen: (subscription) {
          subscription.onData((lux) {
            setState(() {
              _isDarkMode = lux < 50;
            });
          });
        },
      );
    } else {
      print('Have no sensor');
    }
    // LightSensor.lightSensorStream.listen((lux) {
    //   setState(() {
    //     _isDarkMode = lux < 50;
    //   });
    // });
  }
}

// 2. Shake to Swap Message Position
class ShakeSwapMessagesPage extends StatefulWidget {
  @override
  _ShakeSwapMessagesPageState createState() => _ShakeSwapMessagesPageState();
}

class _ShakeSwapMessagesPageState extends State<ShakeSwapMessagesPage> {
  bool isSwapped = false;
  ShakeDetector? detector;

  @override
  void initState() {
    super.initState();
    detector = ShakeDetector.autoStart(onPhoneShake: () {
      setState(() {
        isSwapped = !isSwapped;
      });
    });
  }

  @override
  void dispose() {
    detector?.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: isSwapped ? Alignment.centerRight : Alignment.centerLeft,
            child: ChatBubble(text: "Received message", isSent: !isSwapped),
          ),
          Align(
            alignment: isSwapped ? Alignment.centerLeft : Alignment.centerRight,
            child: ChatBubble(text: "Sent message", isSent: isSwapped),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isSent;

  ChatBubble({required this.text, required this.isSent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: isSent ? Colors.blue : Colors.grey[300],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(text,
          style: TextStyle(color: isSent ? Colors.white : Colors.black)),
    );
  }
}

// 3. Gyroscope Emoji Reaction
class GyroEmojiReactionPage extends StatefulWidget {
  @override
  _GyroEmojiReactionPageState createState() => _GyroEmojiReactionPageState();
}

class _GyroEmojiReactionPageState extends State<GyroEmojiReactionPage> {
  String emojiReaction = "😊";
  final double tiltThreshold = 2.0;

  @override
  void initState() {
    super.initState();
    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        if (event.y > tiltThreshold) {
          emojiReaction = "😂";
        } else if (event.y < -tiltThreshold) {
          emojiReaction = "❤️";
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Tilt left/right to react!", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text(
              emojiReaction,
              style: TextStyle(fontSize: 60),
            ),
          ],
        ),
      ),
    );
  }
}

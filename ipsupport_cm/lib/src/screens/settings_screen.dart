import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen_wake/flutter_screen_wake.dart';
import 'package:ipsupport_cm/src/screens/biometric_screen.dart';
import 'package:ipsupport_cm/src/screens/about_screen.dart';
import 'help_support_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = false;
  bool preciseLocationEnabled = false;

  double brigtness = 0.0;
  bool toggle = false;

  Future<void> initPlatformBrightness() async {
    double bright;
    try {
      bright = await FlutterScreenWake.brightness;
    } on PlatformException {
      bright = 1.0;
    }

    if (!mounted) return;
    setState(() {
      brigtness = bright;
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformBrightness();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Definições'),
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(color: Colors.black26, spreadRadius: 1, blurRadius: 1)
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    AnimatedCrossFade(
                        firstChild: const Icon(
                          Icons.brightness_7,
                          size: 50,
                        ),
                        secondChild: const Icon(
                          Icons.brightness_3,
                          size: 50,
                        ),
                        crossFadeState: toggle
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(seconds: 1)),
                    Expanded(
                        child: Slider(
                      value: brigtness,
                      onChanged: (value) {
                        setState(() {
                          brigtness = value;
                        });
                        FlutterScreenWake.setBrightness(value);
                        if (brigtness == 0.0) {
                          toggle = true;
                        } else {
                          toggle = false;
                        }
                      },
                    ))
                  ],
                ),
                const Text("Ajuste o brilho do ecrã")
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Text(
              'App',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: ListTile(
              title: const Text(
                'Ajuda',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HelpAndSupport()));
                // Lógica para lidar com o clique em "Ajuda"
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: ListTile(
              title: const Text(
                'Sobre',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                // Lógica para lidar com o clique em "Sobre"
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const About()));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: ListTile(
              title: const Text(
                'Sair da conta',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const BiometricSensorPage()));
              },
            ),
          ),
        ],
      ),
    );
  }
}

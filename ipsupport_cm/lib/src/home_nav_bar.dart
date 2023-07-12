import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ipsupport_cm/src/screens/home_map_screen.dart';
import 'package:ipsupport_cm/src/screens/report_screen.dart';
import 'package:light/light.dart';
import 'package:shake/shake.dart';
import 'screens/profile_screen.dart';
// import 'package:light/light.dart';
/*import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ipsupport_cm/src/local_push_notification.dart';*/

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentTab = 1;
  final List<Widget> screens = [const Report(), HomeMapScreen(), Profile()];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = HomeMapScreen();

//--------------------Luminosidade-----------------------------
  StreamSubscription<int>? _subscription;
  double _luxValue = 0.0;
  ShakeDetector? detector;
  Brightness _currentBrightness = Brightness.light;
  Brightness _defaultBrightness = Brightness.light;

  @override
  void initState() {
    super.initState();
    _initLightSensor();
    // para iniciar a leitura do sensor
    initShaker();
  }

  void initShaker() {
    detector = ShakeDetector.autoStart(
        minimumShakeCount: 2,
        shakeCountResetTime: 1000,
        onPhoneShake: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const Home()));
        });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    detector?.stopListening();
    super.dispose();
  }

  void _initLightSensor() {
    _subscription = Light().lightSensorStream.listen(
      (int event) {
        setState(() {
          _luxValue = event.toDouble();
          _adjustBrightness();
        });
      },
      onError: (e) {
        print(e.toString());
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('Falhou a obter dados do sensor de luz!'),
              backgroundColor: Colors.red,
            ),
          );
      },
      cancelOnError: true,
    );
  }

  void _adjustBrightness() {
    if (_luxValue < 50) {
      if (_currentBrightness != Brightness.dark) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        setState(() {
          _currentBrightness = Brightness.dark;
        });
      }
    } else {
      if (_currentBrightness != _defaultBrightness) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
        setState(() {
          _currentBrightness = _defaultBrightness;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "btn1",
        child: const Icon(Icons.assistant_navigation),
        onPressed: () {
          if (currentTab == 1) {
            currentScreen = HomeMapScreen();
          } else {
            setState(() {
              currentScreen = HomeMapScreen();
              currentTab = 1;
            });
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = const Report();
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              right: 60.0), // Padding para o ícone
                          child: Icon(
                            Icons.report_problem_rounded,
                            color: currentTab == 0 ? Colors.blue : Colors.grey,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              right: 60.0), // Padding para o texto
                          child: Text(
                            'Reporte',
                            style: TextStyle(
                              color:
                                  currentTab == 0 ? Colors.blue : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Profile Button
                  MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          currentScreen = Profile();
                          currentTab = 2;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person,
                            color: currentTab == 2 ? Colors.blue : Colors.grey,
                          ),
                          Text(
                            'Perfil',
                            style: TextStyle(
                                color: currentTab == 2
                                    ? Colors.blue
                                    : Colors.grey),
                          )
                        ],
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

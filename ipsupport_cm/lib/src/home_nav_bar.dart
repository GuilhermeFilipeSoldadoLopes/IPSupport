import 'package:flutter/material.dart';
import 'package:ipsupport_cm/src/screens/home_map_screen.dart';
import 'package:ipsupport_cm/src/screens/report_screen.dart';
import 'screens/profile_screen.dart';
// import 'package:light/light.dart';
import 'dart:async';
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
  /*StreamSubscription<int>? _subscription;
  double _luxValue = 0.0;

  @override
  void initState() {
    super.initState();
    _initLightSensor(); // para iniciar a leitura do sensor
  }

  void _initLightSensor() {
    _subscription = Light().lightSensorStream.listen(
      (int event) {
        setState(() {
          _luxValue = event.toDouble();
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
  }*/
  //-------------Fim Luminosidade----------------------


  /*final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool isLoading = false;

  storeNotificationToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({'token': token}, SetOptions(merge: true));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });
    storeNotificationToken();
  }

  sendNotification(String title, String token) async {
    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'message': title,
    };

    try {
      http.Response response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization':
                    'key=AAAAN4wcvJc:APA91bHRIXmGWT71dfLGrT5ehMagfv9t0otf6unXgdTeiiW3f79bmaFJxSNfv-IbRitLQ74dHyADrywVYp1jeC4h__eCfnwFPtA0RA-vAZn_Xb6tvgKk6HUqlEF9uJrnsxGX70066bWx'
              },
              body: jsonEncode(<String, dynamic>{
                'notification': <String, dynamic>{
                  'title': title,
                  'body': 'You are followed by someone'
                },
                'priority': 'high',
                'data': data,
                'to': '$token'
              }));

      if (response.statusCode == 200) {
        print("Yeh notificatin is sended");
      } else {
        print("Error");
      }
    } catch (e) {}
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ipsupport_cm/api/firebase_api.dart';
import 'package:ipsupport_cm/src/home_nav_bar.dart';
import 'package:ipsupport_cm/src/screens/report_screen.dart';
import 'package:ipsupport_cm/src/screens/signin_screen.dart';
import 'package:shake/shake.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();
  
  MaterialApp(
      title: 'IPSupport',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SingInScreen());
      
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return const MaterialApp(home: SingInScreen());
    }
    /*
    ShakeDetector detector = ShakeDetector.autoStart(
      onPhoneShake: () {
        Navigator.push(
                      context,
                      MaterialPageRoute( builder: (context) => const Report()));
      }
    );
    */
    return const MaterialApp(home: Home());
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ipsupport_cm/src/home_nav_bar.dart';
import 'package:ipsupport_cm/src/screens/signin_screen.dart';
import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

/// The above code is a Dart code snippet that initializes Firebase, sets up the main app, and
/// determines whether to show the sign-in screen or the home screen based on the current user's
/// authentication status.
void main() async {
  /// `WidgetsFlutterBinding.ensureInitialized();` ensures that the Flutter framework is properly
  /// initialized before running any code. It is typically used in the `main()` function to ensure that
  /// all necessary bindings are set up before the app starts.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
    } else {
      return const MaterialApp(home: Home());
    }
  }
}

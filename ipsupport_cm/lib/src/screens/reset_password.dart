import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ipsupport_cm/src/screens/feedback_page.dart';
import 'package:ipsupport_cm/src/utils/reusable_widgets/reusable_widgets.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

/// The `ResetPassword` class is a Flutter widget that allows users to reset their password by entering
/// their email and sending a password reset email.
class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController _emailTextController = TextEditingController();
  String errorEmailMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Recuperar Password",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Insira email", Icons.person_outline, false,
                    _emailTextController),
                Text(
                  errorEmailMessage,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                firebaseUIButton(context, "Recuperar Password", () {
                  bool isValid = false;

                  if (_emailTextController.text.isEmpty) {
                    errorEmailMessage = 'Email necessário.';
                    isValid = false;
                  } else {
                    errorEmailMessage = '';
                    isValid = true;
                  }

                  String patternE = r'\w+@\w+\.\w+';
                  RegExp regexE = RegExp(patternE);
                  if (!regexE.hasMatch(_emailTextController.text)) {
                    errorEmailMessage = 'Formato de Email inválido.';
                    isValid = false;
                  } else {
                    errorEmailMessage = '';
                    isValid = true;
                  }

                  if (isValid) {
                    OverlayLoadingProgress.start(context);

                    FirebaseAuth.instance
                        .sendPasswordResetEmail(
                            email: _emailTextController.text)
                        .then((value) {
                      OverlayLoadingProgress.stop();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FeedbackPage()));
                    }).onError((error, stackTrace) {
                      if (error.toString().contains('(auth/user-not-found)')) {
                        errorEmailMessage =
                            'Não existe conta com o Email inserido.';
                      }
                      print(error);
                      print("Error ${error.toString()}");
                      Navigator.of(context).pop();
                      setState(() {});
                    });
                  } else {
                    setState(() {});
                  }
                })
              ],
            ),
          ))),
    );
  }
}

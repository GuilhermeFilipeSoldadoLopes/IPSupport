// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../home_nav_bar.dart';
import '../utils/reusable_widgets/reusable_widgets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  String errorEmailMessage = '';
  String errorPasswordMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Registar",
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
                reusableTextField("Enter username", Icons.person_outline, false,
                    _userNameTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter email", Icons.person_outline, false,
                    _emailTextController),
                Text(
                  errorEmailMessage,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 8,
                ),
                reusableTextField("Enter password", Icons.lock_outlined, true,
                    _passwordTextController),
                Text(
                  errorPasswordMessage,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 8,
                ),
                firebaseUIButton(context, "Registar", () {
                  bool isValid = false;

                  if (_emailTextController.text == null ||
                      _emailTextController.text.isEmpty) {
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

                  if (_passwordTextController.text == null ||
                      _passwordTextController.text.isEmpty) {
                    errorPasswordMessage = 'Password necessária.';
                    isValid = false;
                  } else {
                    errorPasswordMessage = '';
                    isValid = true;
                  }

                  String patternP =
                      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$';
                  RegExp regexP = RegExp(patternP);
                  if (!regexP.hasMatch(_passwordTextController.text)) {
                    errorPasswordMessage =
                        'A Password deverá ter mínimo 8 caracteres, um número, uma letra maiúscula e uma minúscula. Não pode conter caracteres especiais';
                    isValid = false;
                  } else {
                    errorPasswordMessage = '';
                    isValid = true;
                  }

                  if (isValid) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return const Center(
                              child: CircularProgressIndicator());
                        });

                    FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: _emailTextController.text,
                            password: _passwordTextController.text)
                        .then((value) {
                      print("Created New Account");
                      FirebaseAuth.instance.currentUser
                          ?.updateDisplayName(_userNameTextController.text);
                      FirebaseAuth.instance.currentUser?.updatePhotoURL(
                          "https://firebasestorage.googleapis.com/v0/b/ipsupport-28bbe.appspot.com/o/default%2Fdefault_profile.jpg?alt=media&token=83373b6a-6399-4bd4-ac8c-d7f8c203f48a");
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Home()));
                    }).onError((error, stackTrace) {
                      if (error
                          .toString()
                          .contains('(auth/email-already-in-use)')) {
                        errorEmailMessage = 'Email já se encontra em uso.';
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

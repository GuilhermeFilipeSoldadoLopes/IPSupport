// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ipsupport_cm/src/screens/reset_password.dart';
import 'package:ipsupport_cm/src/screens/signup_screen.dart';
import '../../main.dart';
import '../home_nav_bar.dart';
import '../utils/reusable_widgets/reusable_widgets.dart';

class SingInScreen extends StatefulWidget {
  const SingInScreen({Key? key}) : super(key: key);

  @override
  _SingInScreenState createState() => _SingInScreenState();
}

class _SingInScreenState extends State<SingInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  String errorEmailMessage = '';
  String errorPasswordMessage = '';
  bool isLoading = true;
  double progressBar = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            "Entrar",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).size.height * 0.13, 20, 0),
              child: Column(
                children: <Widget>[
                  logoWidget("assets/app/Icon_IPSupport_android.png"),
                  const SizedBox(height: 35),
                  reusableTextField("Insira email", Icons.person_outline, false,
                      _emailTextController),
                  Text(
                    errorEmailMessage,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  reusableTextField("Insira password", Icons.lock_outline, true,
                      _passwordTextController),
                  Text(
                    errorPasswordMessage,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  forgetPassword(context),
                  firebaseUIButton(context, "Entrar", () {
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
                          'A Password deverá ter no mínimo 8 caracteres, um número, uma letra maiúscula e uma minúscula. Não pode conter caracteres especiais';
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
                          .signInWithEmailAndPassword(
                              email: _emailTextController.text,
                              password: _passwordTextController.text)
                          .then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Home()));
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return const MainApp();
                        }));
                      }).onError((error, stackTrace) {
                        if (error
                            .toString()
                            .contains('(auth/user-not-found)')) {
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
                  }),
                  signUpOption()
                ],
              ),
            ),
          ),
        ));
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Não tem conta?",
            style: TextStyle(color: Color.fromARGB(255, 81, 81, 81))),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()));
          },
          child: const Text(
            " Registar",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Esqueceu-se da password?",
          style: TextStyle(color: Color.fromARGB(255, 81, 81, 81)),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ResetPassword())),
      ),
    );
  }
}

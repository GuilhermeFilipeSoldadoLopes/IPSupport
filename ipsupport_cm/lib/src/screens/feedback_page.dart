import 'package:flutter/material.dart';
import 'package:ipsupport_cm/src/screens/signin_screen.dart';

/// The FeedbackPage class is a Flutter widget that displays a message and an image, and provides a
/// button to navigate back to the SignInScreen.
class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar Palavra-Passe'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 10),
          child: Column(
            children: [
              const Text(
                'Foi enviado um email para a sua caixa de correio. Através dele, irá conseguir recuperar a sua palavra passe.',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              Image.asset(
                "assets/app/Icon_IPSupport_android.png",
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SingInScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Voltar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

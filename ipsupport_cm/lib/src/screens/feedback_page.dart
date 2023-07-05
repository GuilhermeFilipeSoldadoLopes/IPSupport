import 'package:flutter/material.dart';

class FeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recuperar Palavra-Passe'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left:10),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
              'Foi enviado um email para a sua caixa de correio. Através dele, irá conseguir recuperar a sua palavra passe.',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Image.asset(
              "assets/app/Icon_IPSupport_android.png",
              width: 200,
              height: 200,
            ),
          ],
        ),
      ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// The above code is a Dart code that implements a Help and Support screen in a Flutter application,
/// allowing users to select a support option, enter a description, and send an email using the EmailJS
/// API.
///
/// Args:
///   name (String): The name of the person sending the email.
///   email (String): The `email` parameter is the email address of the recipient to whom the email will
/// be sent.
///   subject (String): The `subject` parameter is a string that represents the subject of the email
/// that will be sent. It is a required parameter and should be a descriptive title or topic for the
/// email. In the code provided, the `selectedOption` variable is used as the value for the `subject`
/// parameter.
///   message (String): The `message` parameter is a string that represents the content of the email
/// message. It can contain any text or HTML content that you want to include in the email.
class HelpAndSupport extends StatefulWidget {
  const HelpAndSupport({super.key});

  @override
  _HelpAndSupportState createState() => _HelpAndSupportState();
}

class _HelpAndSupportState extends State<HelpAndSupport> {
  TextEditingController textController = TextEditingController();
  String selectedOption = 'Suporte';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajuda'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Radio(
                          value: 'Suporte',
                          groupValue: selectedOption,
                          onChanged: (value) {
                            setState(() {
                              selectedOption = value.toString();
                            });
                          },
                        ),
                      ),
                      const Text('Suporte'),
                    ],
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Radio(
                          value: 'Reporte um bug',
                          groupValue: selectedOption,
                          onChanged: (value) {
                            setState(() {
                              selectedOption = value.toString();
                            });
                          },
                        ),
                      ),
                      const Text('Reporte de bugs e erros'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Descrição:'),
            const SizedBox(height: 8),
            Expanded(
              child: TextFormField(
                controller: textController,
                minLines: 8,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'Escreva aqui...',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color.fromARGB(255, 225, 245, 253),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (textController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Descrição é obrigatória.")));
                    } else {
                      sendEmail(
                          name:
                              FirebaseAuth.instance.currentUser?.displayName ??
                                  "fail",
                          email: FirebaseAuth.instance.currentUser?.email ??
                              "fail",
                          subject: selectedOption,
                          message: textController.text);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Pedido de ajuda enviado.")));
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Enviar'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The function `sendEmail` sends an email using the EmailJS API with the provided name, email,
/// subject, and message.
///
/// Args:
///   name (String): The name of the person sending the email.
///   email (String): The `email` parameter is the email address of the recipient to whom the email will
/// be sent.
///   subject (String): The subject parameter is the subject of the email that will be sent. It is a
/// required parameter and should be a string.
///   message (String): The `message` parameter is a required string that represents the content of the
/// email message. It can contain any text or HTML content that you want to include in the email.
Future sendEmail({
  required String name,
  required String email,
  required String subject,
  required String message,
}) async {
  const serviceId = 'service_k4cyk5w';
  const templateId = 'template_8qepjed';
  const userId = 'AAFjELN51A9ce9mwq';

  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  final response = await http.post(url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'user_name': name,
          'user_email': email,
          'user_subject': subject,
          'user_message': message,
        }
      }));

  print(response.body);
}

import 'package:flutter/material.dart';
import 'package:ipsupport_cm/main.dart';
import 'package:ipsupport_cm/src/screens/report_screen.dart';

class ReportSuccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/check.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            const Text(
              'Reporte realizado com sucesso',
              style: TextStyle(
                fontSize: 24,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const MainApp();
                }));
              },
              child: const Text('Concluir'),
            ),
          ],
        ),
      ),
    );
  }
}

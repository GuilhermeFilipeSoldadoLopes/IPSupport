import 'package:flutter/material.dart';
import 'package:ipsupport_cm/src/screens/report_screen.dart';

class ReportSuccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sucesso'),
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
            SizedBox(height: 20),
            Text(
              'Reporte realizado com sucesso',
              style: TextStyle(
                fontSize: 24,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Report()));
              },
              child: Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}

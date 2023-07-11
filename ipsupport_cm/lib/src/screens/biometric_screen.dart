import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ipsupport_cm/main.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

class BiometricSensorPage extends StatefulWidget {
  const BiometricSensorPage({super.key});

  @override
  State<BiometricSensorPage> createState() => _BiometricSensorPageState();
}

class _BiometricSensorPageState extends State<BiometricSensorPage> {
  final LocalAuthentication _localAuth = LocalAuthentication();

  bool? _isAuthenticated;

  Future<void> _localAuthenticate() async {
    try {
      _isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Necessário verificação biométrica para sair da conta',
      );
      setState(() {});
    } on PlatformException catch (e) {
      log(e.toString());
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content:
                Text('Ocorreu um erro ao tentar fazer verificação biométrica'),
            backgroundColor: Colors.red,
          ),
        );
    }
  }

  void authenticated() async {
    FirebaseAuth.instance.signOut();
    OverlayLoadingProgress.start(context);
    sleep(const Duration(seconds: 1));
    OverlayLoadingProgress.stop();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return const MainApp();
    }));
  }

  Widget _buildStatusTile() {
    var title = "Clique";
    var message = "Toque no botão para iniciar a verificação biométrica";
    var icon = Icons.settings_power;
    var colorIcon = Colors.yellow;

    if (_isAuthenticated == true) {
      title = "Ótimo";
      message = "Verificação biométrica funcionou!";
      icon = Icons.beenhere;
      colorIcon = Colors.green;
      authenticated();
    } else if (_isAuthenticated == false) {
      title = "Ops";
      message = "Tente novamente!";
      icon = Icons.clear;
      colorIcon = Colors.red;
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      leading: Icon(
        icon,
        color: colorIcon,
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 30),
      ),
      subtitle: Text(
        message,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verificação biométrica"),
      ),
      backgroundColor: Colors.grey,
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.symmetric(vertical: 64, horizontal: 16),
            child: _buildStatusTile(),
          ),
          SizedBox(
            width: 100,
            height: 50,
            child: ElevatedButton(
              onPressed: _localAuthenticate,
              child: const Icon(Icons.fingerprint),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text('Cancelar'),
            ),
          ),
        ],
      ),
    );
  }
}

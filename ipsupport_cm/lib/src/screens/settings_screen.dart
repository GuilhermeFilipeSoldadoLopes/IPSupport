import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ipsupport_cm/src/home_nav_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool preciseLocationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Definições'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            child: ListTile(
              title: const Text('Notificações'),
              trailing: Switch(
                value: notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    notificationsEnabled = value;
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: ListTile(
              title: const Text('Localização precisa'),
              trailing: Switch(
                value: preciseLocationEnabled,
                onChanged: (value) {
                  setState(() {
                    preciseLocationEnabled = value;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Text(
              'App',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: ListTile(
              title: const Text(
                'Ajuda',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                // Lógica para lidar com o clique em "Ajuda"
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: ListTile(
              title: const Text(
                'Sobre',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                // Lógica para lidar com o clique em "Sobre"
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: ListTile(
              title: const Text(
                'Sair da conta',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Home()));
              },
            ),
          ),
        ],
      ),
    );
  }
}

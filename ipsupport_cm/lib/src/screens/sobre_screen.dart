import 'package:flutter/material.dart';

class SobrePage extends StatelessWidget {
  const SobrePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 10),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Somos uma Equipa de Estudantes de Engenharia Informática do IPS, que desenvolveu a aplicação de Reporte de problemas denominada IPSupport. A aplicação tem como objetivo unir a comunidade IPS e facilitar a resolução de problemas diários que ocorrem no Campus.',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              Image.asset(
                "assets/app/Icon_IPSupport_android.png",
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20),
              const Text('João Afonso - nº202000813',
                  style: TextStyle(fontSize: 20)),
              const Text('Guilherme Lopes - nº202002400',
                  style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}

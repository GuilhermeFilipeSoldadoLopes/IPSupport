import 'package:flutter/material.dart';

class EquipamentoDanificadoPage extends StatefulWidget {
  const EquipamentoDanificadoPage({Key? key}) : super(key: key);

  @override
  _EquipamentoDanificadoPageState createState() =>
      _EquipamentoDanificadoPageState();
}

class _EquipamentoDanificadoPageState extends State<EquipamentoDanificadoPage> {
  String? selectedOption = 'partido';
  bool isUrgent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Equipamento Danificado'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: const Text('Partido'),
                          leading: Radio(
                            value: 'partido',
                            groupValue: selectedOption,
                            onChanged: (value) {
                              setState(() {
                                selectedOption = value as String?;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('Problemas Técnicos'),
                          leading: Radio(
                            value: 'problemas_tecnicos',
                            groupValue: selectedOption,
                            onChanged: (value) {
                              setState(() {
                                selectedOption = value as String?;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('Não Funcional'),
                          leading: Radio(
                            value: 'nao_funcional',
                            groupValue: selectedOption,
                            onChanged: (value) {
                              setState(() {
                                selectedOption = value as String?;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Padding(
                    padding: const EdgeInsets.only(right: 25.0),
                    child: Container(
                      width: 80,
                      height: 80,
                      child: Image.asset(
                        'assets/images/equipamento_danificado.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Descrição:'),
              const SizedBox(height: 8),
              TextFormField(
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Color.fromARGB(255, 214, 242, 255),
                  filled: true,
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: isUrgent,
                      onChanged: (value) {
                        setState(() {
                          isUrgent = value ?? false;
                        });
                      },
                    ),
                    const Text('Problema Urgente',style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    // Lógica para reportar
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Reportar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

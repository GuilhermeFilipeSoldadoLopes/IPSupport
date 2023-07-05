import 'package:flutter/material.dart';

class EquipamentoDanificadoPage extends StatefulWidget {
  const EquipamentoDanificadoPage({Key? key}) : super(key: key);

  @override
  _EquipamentoDanificadoPageState createState() =>
      _EquipamentoDanificadoPageState();
}

class _EquipamentoDanificadoPageState extends State<EquipamentoDanificadoPage> {
  String? selectedOption;
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Column(
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
              const SizedBox(height: 16),
              const Text('Descrição:'),
              const SizedBox(height: 8),
              TextFormField(
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Color.fromARGB(255, 214, 242, 255),
                  filled: true,
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {

                    // Lógica para lidar com o toque no container
                  },
                  child: Container(
                    width: 200,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 214, 242, 255),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black,
                        width: 0.5,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {

                              // Lógica para adicionar foto
                            },
                            icon: const Icon(Icons.camera_alt),
                          ),
                          const Text('Inserir fotografia'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),



              const SizedBox(height: 16),
              Row(
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
                  const Text('Problema Urgente'),
                ],
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

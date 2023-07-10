import 'package:flutter/material.dart';

class Multibanco extends StatefulWidget {
  const Multibanco({Key? key}) : super(key: key);

  @override
  _Multibanco createState() =>
      _Multibanco();
}

class _Multibanco extends State<Multibanco> {
  String? selectedOption = 'sem_dinheiro';
  bool isUrgent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multibanco'),
      ),
      body: SingleChildScrollView(
        child: Center(
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
                            title: const Text('Sem dinheiro'),
                            leading: Radio(
                              value: 'sem_dinheiro',
                              groupValue: selectedOption,
                              onChanged: (value) {
                                setState(() {
                                  selectedOption = value as String?;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('Sem papel'),
                            leading: Radio(
                              value: 'sem_papel',
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
                    const SizedBox(width: 25, height: 50,),
                    Padding(
                      padding: const EdgeInsets.only(right: 25.0),
                      child: Container(
                        width: 80,
                        height: 80,
                        child: Image.asset(
                          'assets/images/multibanco.png',
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
                      const Text('Problema Urgente',
                          style: TextStyle(fontSize: 15)),
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
    ),
  );
}
}
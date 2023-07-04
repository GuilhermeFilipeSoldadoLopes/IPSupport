import 'package:flutter/material.dart';

class AjudaESuportePage extends StatefulWidget {
  @override
  _AjudaESuportePageState createState() => _AjudaESuportePageState();
}

class _AjudaESuportePageState extends State<AjudaESuportePage> {
  String selectedOption = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () {
                // Código para voltar
              },
            ),
            Expanded(
              child: Center(
                child: Text('Ajuda', style: TextStyle(fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: 'Suporte',
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value.toString();
                          });
                        },
                      ),
                      Text('Suporte'),
                    ],
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: 'Reporte bugs',
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value.toString();
                          });
                        },
                      ),
                      Text('Reporte bugs'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('Descrição:'),
            SizedBox(height: 8),
            Expanded(
              child: TextFormField(
                minLines: 8,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Escreva aqui...',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color.fromARGB(255, 225, 245, 253),
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Lógica para enviar os dados
                },
                child: Text('Enviar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

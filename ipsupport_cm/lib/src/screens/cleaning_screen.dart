import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipsupport_cm/models/reports_models.dart';
import 'package:ipsupport_cm/src/screens/feedback_page.dart';
import 'package:ipsupport_cm/src/screens/report_success.dart';

class Cleaning extends StatefulWidget {
  const Cleaning({Key? key}) : super(key: key);

  @override
  _Cleaning createState() => _Cleaning();
}

class _Cleaning extends State<Cleaning> {
  String? selectedOption = 'objeto_partido';
  bool isUrgent = false;

  final TextEditingController descriptionController = TextEditingController();

  DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  List<Report> reportsList = [];
  bool updateReports = false;
  String? imageUrl;
  String? path;

  void _editImageDialog(BuildContext context) async {
    var pickedImage = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 520,
        maxHeight: 520, //specify size and quality
        imageQuality: 80); //so image_picker will resize for you

    Random random = Random();
    int randomNum = random.nextInt(path!.length);
    String selectedImagePath = path![randomNum];

    print("------------- path: " + selectedImagePath);

    //upload and get download url
    Reference ref = FirebaseStorage.instance
        .ref()
        .child(selectedImagePath); //generate a unique name

    await ref.putFile(File(pickedImage!.path)); //you need to add path here
    imageUrl = await ref.getDownloadURL();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context, {String? key}) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Limpeza'),
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
                            title: const Text('Objeto Partido'),
                            leading: Radio(
                              value: 'Objeto partido',
                              groupValue: selectedOption,
                              onChanged: (value) {
                                setState(() {
                                  selectedOption = value as String?;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('Inundado'),
                            leading: Radio(
                              value: 'Inundado',
                              groupValue: selectedOption,
                              onChanged: (value) {
                                setState(() {
                                  selectedOption = value as String?;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('Sujo'),
                            leading: Radio(
                              value: 'Sujo',
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
                          'assets/images/limpeza.png',
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
                  controller: descriptionController,
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
                      const Text('Problema Urgente',
                          style: TextStyle(fontSize: 15)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Lógica para reportar
                      String date = DateTime.now().toString();

                      Position position = await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.low);

                      Map<String, dynamic> data = {
                        "userName":
                            FirebaseAuth.instance.currentUser?.displayName,
                        "userEmail": FirebaseAuth.instance.currentUser?.email,
                        "description": descriptionController.text,
                        "photoURL": imageUrl ?? "No photo",
                        "problem": "Limpeza",
                        "problemType": selectedOption,
                        "latitude": position.latitude,
                        "longitude": position.longitude,
                        "numReports": 1,
                        "isActive": true,
                        "isUrgent": isUrgent,
                        "creationDate": date,
                        "resolutionDate": null,
                      };

                      if (updateReports) {
                        dbRef
                            .child("Report")
                            .child(key!)
                            .update(data)
                            .then((value) {
                          int index = reportsList
                              .indexWhere((element) => element.key == key);
                          reportsList.removeAt(index);
                          reportsList.insert(
                              index,
                              Report(
                                  key: key,
                                  reportData: ReportData.fromJson(data)));
                          setState(() {});
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReportSuccess()));
                        });
                      } else {
                        dbRef.child("Report").push().set(data).then((value) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const FeedbackPage()));
                        });
                      }
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

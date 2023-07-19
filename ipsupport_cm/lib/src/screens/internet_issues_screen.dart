import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipsupport_cm/models/reports_models.dart';
import 'package:ipsupport_cm/models/user_reports.dart';
import 'package:ipsupport_cm/src/utils/utils.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'report_success.dart';

/// The `InternetIssues` class is a StatefulWidget that allows users to report internet issues,
/// including selecting the type of issue, providing a description, and uploading a photo.
class InternetIssues extends StatefulWidget {
  const InternetIssues({Key? key}) : super(key: key);

  @override
  _InternetIssues createState() => _InternetIssues();
}

class _InternetIssues extends State<InternetIssues> {
  String? selectedOption = 'Falhas';
  bool isUrgent = false;

  final TextEditingController descriptionController = TextEditingController();

  DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  List<Report> reportsList = [];
  bool updateReports = false;
  int _index = -1;
  String? imageUrl;
  String? path;
  String? key;
  bool haveImage = false;

  /// The `_editImageDialog` function allows the user to pick an image from the camera, upload it to
  /// Firebase Storage, and retrieve the download URL.
  ///
  /// Args:
  ///   context (BuildContext): The `BuildContext` is a required parameter in Flutter that represents
  /// the location in the widget tree where the current widget is being built. It is typically used to
  /// access the theme, localization, and other resources of the app.
  void _editImageDialog(BuildContext context) async {
    var pickedImage = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 520,
        maxHeight: 520, //specify size and quality
        imageQuality: 80); //so image_picker will resize for you

    //upload and get download url
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("FotoReport")
        .child(pickedImage!.name); //generate a unique name

    await ref.putFile(File(pickedImage.path)); //you need to add path here
    imageUrl = await ref.getDownloadURL();

    setState(() {
      haveImage = true;
    });
  }

  /// The function retrieves a list of reports from a database and adds them to a reportsList.
  void getReporstList() {
    dbRef.child("Report").onChildAdded.listen((data) {
      ReportData reportData = ReportData.fromJson(data.snapshot.value as Map);
      Report report = Report(key: data.snapshot.key, reportData: reportData);
      reportsList.add(report);
      setState(() {
        key = data.snapshot.key;
      });
    });
  }

  /// The `report()` function is responsible for creating and updating reports in a database based on
  /// user input and current location.
  ///
  /// Returns:
  ///   The function `report()` does not have a return type specified, so it does not explicitly return
  /// anything.
  void report() async {
    String date = DateTime.now().toString();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    for (var i = 0; i < reportsList.length; i++) {
      if (reportsList[i].reportData!.resolutionDate == "Not resolved") {
        if (reportsList[i].reportData!.problem == "Internet" &&
            reportsList[i].reportData!.problemType == selectedOption) {
          if (distance(
                  reportsList[i].reportData!.latitude!,
                  reportsList[i].reportData!.longitude!,
                  position.latitude,
                  position.longitude) <=
              0.007) {
            if (reportsList[i].reportData!.isUrgent == isUrgent) {
              setState(() {
                updateReports = true;
                _index = i;
              });
            }
          }
        }
      }
    }

    Map<String, dynamic> data = {
      "userName": FirebaseAuth.instance.currentUser?.displayName,
      "userEmail": FirebaseAuth.instance.currentUser?.email,
      "description": descriptionController.text,
      "photoURL": imageUrl ?? "No photo",
      "problem": "Internet",
      "problemType": selectedOption,
      "latitude": position.latitude,
      "longitude": position.longitude,
      "numReports": 1,
      "isActive": false,
      "isUrgent": isUrgent,
      "creationDate": date,
      "resolutionDate": "Not resolved",
    };

    if (descriptionController.text.isNotEmpty && imageUrl != null) {
      data = {
        "userName": FirebaseAuth.instance.currentUser?.displayName,
        "userEmail": FirebaseAuth.instance.currentUser?.email,
        "description": descriptionController.text,
        "photoURL": imageUrl ?? "No photo",
        "problem": "Internet",
        "problemType": selectedOption,
        "latitude": position.latitude,
        "longitude": position.longitude,
        "numReports": 1,
        "isActive": true,
        "isUrgent": isUrgent,
        "creationDate": date,
        "resolutionDate": "Not resolved",
      };
    }

    if (updateReports) {
      if (reportsList[_index].reportData!.description!.isEmpty &&
          reportsList[_index].reportData!.photoURL! == "No photo") {
        data = {
          "userName": reportsList[_index].reportData!.userName,
          "userEmail": reportsList[_index].reportData!.userEmail,
          "description": descriptionController.text.isEmpty
              ? reportsList[_index].reportData!.description
              : descriptionController.text,
          "photoURL": imageUrl ?? "No photo",
          "problem": "Internet",
          "problemType": selectedOption,
          "latitude": reportsList[_index].reportData!.latitude,
          "longitude": reportsList[_index].reportData!.longitude,
          "numReports": reportsList[_index].reportData!.numReports! + 1,
          "isActive": true,
          "isUrgent": reportsList[_index].reportData!.isUrgent,
          "creationDate": reportsList[_index].reportData!.creationDate,
          "resolutionDate": "Not resolved",
        };
      } else if (reportsList[_index].reportData!.description!.isEmpty) {
        data = {
          "userName": reportsList[_index].reportData!.userName,
          "userEmail": reportsList[_index].reportData!.userEmail,
          "description": descriptionController.text.isEmpty
              ? reportsList[_index].reportData!.description
              : descriptionController.text,
          "photoURL": reportsList[_index].reportData!.photoURL,
          "problem": "Internet",
          "problemType": selectedOption,
          "latitude": reportsList[_index].reportData!.latitude,
          "longitude": reportsList[_index].reportData!.longitude,
          "numReports": reportsList[_index].reportData!.numReports! + 1,
          "isActive": true,
          "isUrgent": reportsList[_index].reportData!.isUrgent,
          "creationDate": reportsList[_index].reportData!.creationDate,
          "resolutionDate": "Not resolved",
        };
      } else if (reportsList[_index].reportData!.photoURL! == "No photo") {
        data = {
          "userName": reportsList[_index].reportData!.userName,
          "userEmail": reportsList[_index].reportData!.userEmail,
          "description": reportsList[_index].reportData!.description,
          "photoURL": imageUrl ?? "No photo",
          "problem": "Internet",
          "problemType": selectedOption,
          "latitude": reportsList[_index].reportData!.latitude,
          "longitude": reportsList[_index].reportData!.longitude,
          "numReports": reportsList[_index].reportData!.numReports! + 1,
          "isActive": true,
          "isUrgent": reportsList[_index].reportData!.isUrgent,
          "creationDate": reportsList[_index].reportData!.creationDate,
          "resolutionDate": "Not resolved",
        };
      } else if (reportsList[_index].reportData!.isActive == false &&
          reportsList[_index].reportData!.numReports == 1) {
        data = {
          "userName": reportsList[_index].reportData!.userName,
          "userEmail": reportsList[_index].reportData!.userEmail,
          "description": reportsList[_index].reportData!.description ??
              descriptionController.text,
          "photoURL": imageUrl ?? reportsList[_index].reportData!.photoURL,
          "problem": "Internet",
          "problemType": selectedOption,
          "latitude": reportsList[_index].reportData!.latitude,
          "longitude": reportsList[_index].reportData!.longitude,
          "numReports": reportsList[_index].reportData!.numReports! + 1,
          "isActive": true,
          "isUrgent": reportsList[_index].reportData!.isUrgent,
          "creationDate": reportsList[_index].reportData!.creationDate,
          "resolutionDate": "Not resolved",
        };
      }
    }

    int numReports = 0;
    String? _doc;

    var toMessages = (await db
        .collection("Users")
        .withConverter(
          fromFirestore: UserReports.fromFirestore,
          toFirestore: (UserReports userReports, options) =>
              userReports.toFirestore(),
        )
        .where("email", isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .get());

    toMessages.docs.forEach((doc) {
      _doc = doc.id;
      numReports = int.parse(doc.data().toString());
    });

    FirebaseFirestore.instance.collection("Users").doc(_doc).update({
      "numReports": numReports + 1,
    });

    if (updateReports) {
      dbRef.child("Report").child(key!).update(data).then((value) {
        int index = reportsList.indexWhere((element) => element.key == key);
        reportsList.removeAt(index);
        reportsList.insert(
            index, Report(key: key, reportData: ReportData.fromJson(data)));
        setState(() {});
        OverlayLoadingProgress.stop();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return ReportSuccess();
        }));
      });
    } else {
      dbRef.child("Report").push().set(data).then((value) {
        OverlayLoadingProgress.stop();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return ReportSuccess();
        }));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getReporstList();
  }

  @override
  Widget build(BuildContext context, {String? key}) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Problemas de Internet'),
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
                            title: const Text('Falhas'),
                            leading: Radio(
                              value: 'Falhas',
                              groupValue: selectedOption,
                              onChanged: (value) {
                                setState(() {
                                  selectedOption = value as String?;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('Baixa velocidade'),
                            leading: Radio(
                              value: 'Baixa velocidade',
                              groupValue: selectedOption,
                              onChanged: (value) {
                                setState(() {
                                  selectedOption = value as String?;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('Sem ligação'),
                            leading: Radio(
                              value: 'Sem ligação',
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
                          'assets/images/internet_problem.png',
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
                    hintText: "Descreva o problema aqui...",
                    border: OutlineInputBorder(),
                    fillColor: Color.fromARGB(255, 214, 242, 255),
                    filled: true,
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      width: 200,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 214, 242, 255),
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
                            haveImage
                                ? Card(
                                    clipBehavior: Clip.antiAlias,
                                    child: Image.network(
                                      imageUrl!,
                                      fit: BoxFit.scaleDown,
                                      width: 120,
                                      height: 60,
                                    ))
                                : IconButton(
                                    onPressed: () {
                                      _editImageDialog(context);
                                    },
                                    icon: haveImage
                                        ? const Icon(Icons.check)
                                        : const Icon(Icons.camera_alt),
                                  ),
                            haveImage
                                ? const Text('Fotografia selecionada')
                                : const Text('Inserir fotografia'),
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
                    onPressed: () async {
                      OverlayLoadingProgress.start(context);
                      report();
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

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ipsupport_cm/models/reports_models.dart';
import 'package:ipsupport_cm/models/userReports.dart';
import 'package:ipsupport_cm/src/home_nav_bar.dart';
import 'package:ipsupport_cm/src/screens/report_success.dart';
import 'package:ipsupport_cm/src/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smooth_compass/utils/src/compass_ui.dart';

class MapHome extends StatefulWidget {
  const MapHome({
    required this.controllerCompleter,
    super.key,
  });

  final Completer<GoogleMapController> controllerCompleter;

  @override
  State<MapHome> createState() => _MapHomeState();
}

class _MapHomeState extends State<MapHome> {
  static const CameraPosition _ipsCameraPosition = CameraPosition(
    //target: LatLng(37.421998333333335, -122.084) /*, google*/,
    //target: LatLng(38.656131, -9.173389) /*, casa*/,
    target: LatLng(38.521095, -8.838903) /*, ips*/,

    zoom: 16.1, //10
  );

  DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  List<Report> reportsList = [];
  Set<Marker> markers = <Marker>{};
  String? key;
  bool refresh = false;

  final _polygons = <Polygon>{
    Polygon(
      polygonId: const PolygonId('ips'),
      points: const [
        LatLng(38.52369782149787, -8.842641622206202),
        LatLng(38.517588663290326, -8.838750185915375),
        LatLng(38.519575194826196, -8.835088408159743),
        LatLng(38.523498184000566, -8.838622597840265),
      ],
      fillColor: Colors.blue.withOpacity(0.15),
      strokeColor: Colors.blue,
      strokeWidth: 4,
    ),
  };

  MapType _mapType = MapType.hybrid;

  @override
  void initState() {
    _requestPermission();
    getReporstList();
    updateReportsList();
    super.initState();
  }

  Future<void> _requestPermission() async {
    await Permission.location.request();
  }

  void _onCameraMove(CameraPosition position) {
    //_lastMapPosition = position.target;
    /*print("latitude > " +
        position.target.latitude.toString() +
        ", longitude > " +
        position.target.longitude.toString());*/
  }

  void changeMapType() {
    setState(() {
      _mapType = _mapType == MapType.hybrid ? MapType.normal : MapType.hybrid;
    });
  }

  void zoomOut() async {
    //como verificar se o mapa tem zoom e/ou nao esta na posicao inicial
    final GoogleMapController controller =
        await widget.controllerCompleter.future;
    var zoom = await controller.getZoomLevel();

    if (zoom != 16.1) {
      await controller
          .animateCamera(CameraUpdate.newCameraPosition(_ipsCameraPosition));
    }
  }

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

  void updateReportsList() {
    Map<String, dynamic> data;
    for (var i = 0; i < reportsList.length; i++) {
      if (DateTime.now().isAfter(
          DateTime.parse(reportsList[i].reportData!.creationDate!)
              .add(const Duration(hours: 36)))) {
        data = {
          "userName": reportsList[i].reportData!.userName,
          "userEmail": reportsList[i].reportData!.userEmail,
          "description": reportsList[i].reportData!.description,
          "photoURL": reportsList[i].reportData!.photoURL,
          "problem": reportsList[i].reportData!.problem,
          "problemType": reportsList[i].reportData!.problemType,
          "latitude": reportsList[i].reportData!.latitude,
          "longitude": reportsList[i].reportData!.longitude,
          "numReports": reportsList[i].reportData!.numReports,
          "isActive": false,
          "isUrgent": reportsList[i].reportData!.isUrgent,
          "creationDate": reportsList[i].reportData!.creationDate,
          "resolutionDate": DateTime.now().toString(),
        };
        reportsList.removeAt(i);
        reportsList.insert(
            i, Report(key: key, reportData: ReportData.fromJson(data)));
        setState(() {});
      }

      if (reportsList[i].reportData!.isActive == false) {
        reportsList.removeAt(i);
        setState(() {});
      }
    }
    createMarkers();
  }

  void createMarkers() async {
    for (var i = 0; i < reportsList.length; i++) {
      if (reportsList[i].reportData!.isActive == true &&
          reportsList[i].reportData!.resolutionDate == "Not resolved") {
        String? problema = reportsList[i].reportData!.problem;
        bool isUrgent = reportsList[i].reportData!.isUrgent ?? false;

        String nomeImagem = problema!.toLowerCase();
        if (isUrgent) {
          nomeImagem = nomeImagem + "_urgente";
        }
        BitmapDescriptor markerIcon = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(),
          "assets/images/pin_" + nomeImagem + ".png",
        );

        double latitude = reportsList[i].reportData!.latitude ?? 0;
        double longitude = reportsList[i].reportData!.longitude ?? 0;
        addMarker(reportsList[i].reportData!, markerIcon, latitude, longitude);
      }
    }
  }

  void addMarker(ReportData reportData, BitmapDescriptor markerIcon,
      double latitude, double longitude) {
    setState(() {
      markers.add(Marker(
          markerId: MarkerId(reportData.creationDate!),
          position: LatLng(latitude, longitude),
          onTap: () {
            showBottomSheet(context, reportData);
          },
          icon: markerIcon));
    });
  }

  void reportButton(ReportData reportData) async {
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

    Map<String, dynamic> data = {
      "userName": reportData.userName,
      "userEmail": reportData.userEmail,
      "description": reportData.description,
      "photoURL": reportData.photoURL,
      "problem": reportData.problem,
      "problemType": reportData.problemType,
      "latitude": reportData.latitude,
      "longitude": reportData.longitude,
      "numReports": reportData.numReports! + 1,
      "isActive": reportData.isActive,
      "isUrgent": reportData.isUrgent,
      "creationDate": reportData.creationDate,
      "resolutionDate": reportData.resolutionDate,
    };

    dbRef.child("Report").child(key!).update(data).then((value) {
      int index = reportsList.indexWhere((element) => element.key == key);
      reportsList.removeAt(index);
      reportsList.insert(
          index, Report(key: key, reportData: ReportData.fromJson(data)));
      setState(() {});
    });
  }

  void resolvedButton(ReportData reportData) {
    Map<String, dynamic> data = {
      "userName": reportData.userName,
      "userEmail": reportData.userEmail,
      "description": reportData.description,
      "photoURL": reportData.photoURL,
      "problem": reportData.problem,
      "problemType": reportData.problemType,
      "latitude": reportData.latitude,
      "longitude": reportData.longitude,
      "numReports": reportData.numReports,
      "isActive": false,
      "isUrgent": reportData.isUrgent,
      "creationDate": reportData.creationDate,
      "resolutionDate": DateTime.now().toString(),
    };

    dbRef.child("Report").child(key!).update(data).then((value) {
      int index = reportsList.indexWhere((element) => element.key == key);
      reportsList.removeAt(index);
      reportsList.insert(
          index, Report(key: key, reportData: ReportData.fromJson(data)));
      setState(() {});
    });

    setState(() {
      markers.removeWhere(
          (element) => element.markerId == MarkerId(reportData.creationDate!));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!refresh) {
      updateReportsList();
    }
    if (markers.isNotEmpty && !refresh) {
      setState(() {
        refresh = true;
      });
    }

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _ipsCameraPosition,
          mapType: _mapType,
          trafficEnabled: false,
          myLocationEnabled: true,
          compassEnabled: false,
          minMaxZoomPreference: const MinMaxZoomPreference(16.1, 20),
          layoutDirection: TextDirection.ltr,
          indoorViewEnabled: false,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          zoomGesturesEnabled: true,
          rotateGesturesEnabled: true,
          scrollGesturesEnabled: false,
          markers: markers,
          polygons: _polygons,
          onCameraMove: _onCameraMove,
          onMapCreated: (GoogleMapController controller) {
            widget.controllerCompleter.complete(controller);
          },
        ),
        Container(
          margin: const EdgeInsets.only(top: 80, right: 10),
          alignment: Alignment.topRight,
          child: Column(children: <Widget>[
            FloatingActionButton(
                heroTag: "btn2",
                elevation: 5,
                backgroundColor: Colors.blue,
                onPressed: () {
                  changeMapType();
                },
                child: const Icon(Icons.layers)),
          ]),
        ),
        Container(
          margin: const EdgeInsets.only(top: 160, right: 10),
          alignment: Alignment.topRight,
          child: Column(children: <Widget>[
            FloatingActionButton(
                heroTag: "btn3",
                elevation: 5,
                backgroundColor: Colors.blue,
                onPressed: () {
                  zoomOut();
                },
                child: const Icon(Icons.zoom_out)),
          ]),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 20, right: 10),
          alignment: Alignment.bottomRight,
          child: SmoothCompass(
            rotationSpeed: 200,
            height: 300,
            width: 300,
            compassAsset: Image.asset(
              "assets/images/compass.png",
              height: 70,
              width: 70,
            ),
          ),
        ),
      ],
    );
  }

  void showBottomSheet(BuildContext context, ReportData reportData) {
    bool isUrgent = reportData.isUrgent ?? false;
    String nomeImagem = reportData.problem!.toLowerCase();
    if (isUrgent) {
      nomeImagem = nomeImagem + "_urgente";
    }

    Duration difference =
        DateTime.now().difference(DateTime.parse(reportData.creationDate!));

    String? problema;
    switch (reportData.problem!) {
      case "Multibanco":
        problema = "Multibanco";
        break;
      case "Vending":
        problema = "Máquina de venda";
        break;
      case "Limpeza":
        problema = "Limpeza";
        break;
      case "Equipamento":
        problema = "Equipamento danificado";
        break;
      case "Internet":
        problema = "Problemas de internet";
        break;
      default:
        problema = "Erro ...";
    }

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Color.fromARGB(255, 213, 234, 252),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Image.asset(
                        "assets/images/circle_" + nomeImagem + ".png",
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(height: 1.0),
                      isUrgent
                          ? const Text(
                              'Problema Urgente',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            )
                          : const Text(
                              'Problema Normal',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                              ),
                            ),
                    ],
                  ),
                  const SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        problema!,
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        reportData.problemType!,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    flex: 6, // 60% da row
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: Colors.black,
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        reportData.description!.isEmpty ? "Sem descrição" : reportData.description!,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    flex: 4, // 40% da row
                    child: Container(
                      width: 90,
                      height: 80,
                      child: reportData.photoURL! == "No photo"
                          ? const Text("Sem imagem", textAlign: TextAlign.center)
                          : Image.network(reportData.photoURL!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  width: MediaQuery.of(context).size.width * 0.6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info,
                        size: 28,
                      ),
                      const SizedBox(width: 8.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Número de Reportes: ' +
                                reportData.numReports!.toString(),
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            'Ativo desde: ' +
                                difference.inHours.toString() +
                                "h:" +
                                (difference.inMinutes - difference.inHours * 60).toString() +
                                "m",
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 130,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        reportButton(reportData);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) {
                            return ReportSuccess();
                          }),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Reportar'),
                    ),
                  ),
                  Container(
                    width: 130,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        resolvedButton(reportData);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) {
                            return const Home();
                          }),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Resolvido'),
                    ),
                  ),
                ],
              ),

            ],
          ),
        );
      },
    );
  }
}

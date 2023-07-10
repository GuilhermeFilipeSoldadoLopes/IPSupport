import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ipsupport_cm/models/reports_models.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smooth_compass/utils/src/compass_ui.dart';

import '../../home_nav_bar.dart';

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
    target: LatLng(38.521095, -8.838903),
    zoom: 16.1, //10
  );

  DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  List<Report> reportsList = [];
  bool updateReports = false;
  Set<Marker> markers = <Marker>{};

  /*final _markers = <Marker>{
    Marker(
      markerId: const MarkerId('ess'),
      position: const LatLng(38.52275567301086, -8.841010269144789),
      infoWindow: const InfoWindow(
        title: 'ESS',
        snippet: 'Escola Superior de Saúde',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
    ),
    Marker(
      markerId: const MarkerId('esce'),
      position: const LatLng(38.52266940145118, -8.841144169323442),
      infoWindow: const InfoWindow(
        title: 'ESCE',
        snippet: 'Escola Superior de Ciências Empresariais',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    ),
    Marker(
      markerId: const MarkerId('ese'),
      position: const LatLng(38.520075729121054, -8.838204661370296),
      infoWindow: const InfoWindow(
        title: 'ESE',
        snippet: 'Escola Superior de Educação',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    ),
    Marker(
      markerId: const MarkerId('ests'),
      position: const LatLng(38.52199531703995, -8.838600716392541),
      infoWindow: const InfoWindow(
        title: 'ESTS',
        snippet: 'Escola Superior de Tecnologia de Setúbal',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    ),
    Marker(
      markerId: const MarkerId('estb'),
      position: const LatLng(38.65254138787937, -9.048843018238152),
      infoWindow: const InfoWindow(
        title: 'ESTB',
        snippet: 'Escola Superior de Tecnologia do Barreiro',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
    ),
  };*/

  final _polygons = <Polygon>{
    Polygon(
      polygonId: const PolygonId('ips'),
      points: const [
        LatLng(38.52369782149787, -8.842641622206202),
        LatLng(38.517588663290326, -8.838750185915375),
        LatLng(38.519575194826196, -8.835088408159743),
        LatLng(38.523498184000566, -8.838622597840265),
      ],
      fillColor: Colors.green.withOpacity(0.3),
      strokeColor: Colors.green,
      strokeWidth: 4,
    ),
  };

  MapType _mapType = MapType.hybrid;

  @override
  void initState() {
    _requestPermission();
    _loadIpsLogoIcon();

    super.initState();
  }

  Future<void> _requestPermission() async {
    await Permission.location.request();
  }

  void _loadIpsLogoIcon() async {}

  void _onCameraMove(CameraPosition position) {
    //_lastMapPosition = position.target;
  }

  void _changeMapType() {
    setState(() {
      _mapType = _mapType == MapType.hybrid ? MapType.normal : MapType.hybrid;
    });
  }

  void _zoom_out() {
    //como verificar se o mapa tem zoom e/ou nao esta na posicao inicial
    setState(() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Home()));
    });
  }

  void retrieveReportsData() {
    dbRef.child("Reports").onChildAdded.listen((data) {
      ReportData reportData = ReportData.fromJson(data.snapshot.value as Map);
      Report report = Report(key: data.snapshot.key, reportData: reportData);
      reportsList.add(report);
      setState(() {});

      dbRef.child("Reports").push().set(data).then((value) {
        for (var i = 0; i < reportsList.length; i++) {
          if (DateTime.now().isAfter(
              DateTime.parse(reportsList[i].reportData!.creationDate!)
                  .add(const Duration(hours: 36)))) {
            reportsList[i].reportData!.isActive = false;
          }

          if (reportsList[i].reportData!.isActive == false) {
            reportsList.removeAt(i);
          }
        }

        for (var i = 0; i < reportsList.length; i++) {
          Marker _marker = Marker(
            markerId: MarkerId('ests'),
            /*position: const LatLng(38.52199531703995, -8.838600716392541),
            infoWindow: const InfoWindow(
              title: 'ESTS',
              snippet: 'Escola Superior de Tecnologia de Setúbal',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueYellow),*/
          );

          //reportsList[i].reportData!.userName;

          markers.add(_marker);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _ipsCameraPosition,
          mapType: _mapType,
          trafficEnabled: false,
          myLocationEnabled: true,
          compassEnabled: true,
          minMaxZoomPreference: const MinMaxZoomPreference(16.1, 20),
          layoutDirection: TextDirection.ltr,
          indoorViewEnabled: false,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          zoomGesturesEnabled: true,
          rotateGesturesEnabled: false,
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
                elevation: 5,
                backgroundColor: Colors.blue,
                onPressed: () {
                  _changeMapType();
                },
                child: const Icon(Icons.layers)),
          ]),
        ),
        Container(
          margin: const EdgeInsets.only(top: 160, right: 10),
          alignment: Alignment.topRight,
          child: Column(children: <Widget>[
            FloatingActionButton(
                elevation: 5,
                backgroundColor: Colors.blue,
                onPressed: () {
                  _zoom_out();
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
}

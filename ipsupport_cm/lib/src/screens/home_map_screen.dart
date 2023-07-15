import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ipsupport_cm/src/screens/widgets_map/map_home.dart';

/// The HomeMapScreen class is a Flutter widget that displays a Google Map using the MapHome widget.
class HomeMapScreen extends StatelessWidget {
  HomeMapScreen({super.key});

  final Completer<GoogleMapController> _controllerCompleter =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapHome(controllerCompleter: _controllerCompleter),
    );
  }
}

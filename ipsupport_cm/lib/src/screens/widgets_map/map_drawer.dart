import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapDrawer extends StatelessWidget {
  const MapDrawer({
    required this.controllerCompleter,
    super.key,
  });

  final Completer<GoogleMapController> controllerCompleter;

  Future<void> _goToLisbon() async {
    double lat = 38.72272978721572;
    double long = -9.142007864923725;
    double zoom = 10;
    GoogleMapController controller = await controllerCompleter.future;
    controller
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, long), zoom));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 16.0,
      child: Column(
        children: <Widget>[
          const UserAccountsDrawerHeader(
            accountName: Text("xyz"),
            accountEmail: Text("xyz@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text("xyz"),
            ),
            otherAccountsPictures: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Text("abc"),
              )
            ],
          ),
          const ListTile(
            title: Text("Locais"),
            leading: Icon(Icons.flight),
          ),
          const Divider(),
          ListTile(
            onTap: () {
              _goToLisbon();
              Navigator.of(context).pop();
            },
            title: const Text("Lisboa"),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }
}

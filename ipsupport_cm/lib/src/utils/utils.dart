import 'dart:math' show asin, cos, pi, pow, sin, sqrt;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

final db = FirebaseFirestore.instance;

/// The function converts a hexadecimal color string to a Dart Color object.
///
/// Args:
///   hexColor (String): The parameter hexColor is a string representing a hexadecimal color value.
///
/// Returns:
///   The method is returning a Color object.
hexStringToColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor == "FF" + hexColor;
  }
  return Color(int.parse(hexColor, radix: 16));
}

/// The function `pickImage` uses the `ImagePicker` package to select an image from a specified source
/// and returns the image as bytes.
///
/// Args:
///   source (ImageSource): The `source` parameter in the `pickImage` function is used to specify the
/// source from where the image should be picked. It can have one of the following values:
///
/// Returns:
///   a `Future<List<int>>` which represents the bytes of the selected image.
pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? file = await _imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
}

/// The function `getLocation` returns a `Future` that resolves to the current position using the
/// Geolocator plugin in Dart.
///
/// Returns:
///   a `Future` object that will eventually resolve to a `Position` object.
Future<Position> getLocation() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low);

  return position;
}

/// The function calculates the distance between two points on Earth using the Haversine formula.
///
/// Args:
///   lat1 (double): The latitude of the first point.
///   lon1 (double): The parameter "lon1" represents the longitude of the first location.
///   lat2 (double): The parameter "lat2" represents the latitude of the second point in degrees.
///   lon2 (double): The parameter "lon2" represents the longitude of the second location.
///
/// Returns:
///   the distance between two points on the Earth's surface in kilometers.
double distance(double lat1, double lon1, double lat2, double lon2) {
  const r = 6372.8; // Earth radius in kilometers

  final dLat = _toRadians(lat2 - lat1);
  final dLon = _toRadians(lon2 - lon1);
  final lat1Radians = _toRadians(lat1);
  final lat2Radians = _toRadians(lat2);

  final a =
      _haversin(dLat) + cos(lat1Radians) * cos(lat2Radians) * _haversin(dLon);
  final c = 2 * asin(sqrt(a));

  return r * c;
}

/// The function `_toRadians` converts degrees to radians in Dart.
///
/// Args:
///   degrees (double): The degrees parameter is a value representing an angle in degrees.
double _toRadians(double degrees) => degrees * pi / 180;

/// The function calculates the haversine of a given angle in radians.
///
/// Args:
///   radians (double): The parameter "radians" is a double value representing an angle in radians.
num _haversin(double radians) => pow(sin(radians / 2), 2);

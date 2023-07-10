import 'package:firebase_database/firebase_database.dart';

DatabaseReference dbRef = FirebaseDatabase.instance.ref();

List<Report> reportsList = [];

bool updateStudent = false;

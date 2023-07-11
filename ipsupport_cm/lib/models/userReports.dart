import 'package:cloud_firestore/cloud_firestore.dart';

class UserReports {
  String? email;
  int? numReports;

  UserReports({
    this.email,
    this.numReports,
  });

  factory UserReports.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserReports(
      email: data?['email'],
      numReports: data?['numReports'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (email != null) "email": email,
      if (numReports != null) "numReports": numReports,
    };
  }

  @override
  String toString() {
    return numReports.toString();
  }
}

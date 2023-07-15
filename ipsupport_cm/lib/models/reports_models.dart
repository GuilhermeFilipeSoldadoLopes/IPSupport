/// The above code defines two classes, Report and ReportData, in Dart for handling report data.
class Report {
  String? key;
  ReportData? reportData;

  Report({this.key, this.reportData});
}

class ReportData {
  String? userName;
  String? userEmail;
  String? description;
  String? photoURL;
  String? problem;
  String? problemType;
  double? latitude;
  double? longitude;
  int? numReports;
  bool? isActive;
  bool? isUrgent;
  String? creationDate;
  String? resolutionDate;

  ReportData(
      {this.userName,
      this.userEmail,
      this.description,
      this.photoURL,
      this.problem,
      this.problemType,
      this.latitude,
      this.longitude,
      this.numReports,
      this.isActive,
      this.isUrgent,
      this.creationDate,
      this.resolutionDate});

  ReportData.fromJson(Map<dynamic, dynamic> json) {
    userName = json["userName"];
    userEmail = json["userEmail"];
    description = json["description"];
    photoURL = json["photoURL"];
    problem = json["problem"];
    problemType = json["problemType"];
    latitude = json["latitude"];
    longitude = json["longitude"];
    numReports = json["numReports"];
    isActive = json["isActive"];
    isUrgent = json["isUrgent"];
    creationDate = json["creationDate"];
    resolutionDate = json["resolutionDate"];
  }
}

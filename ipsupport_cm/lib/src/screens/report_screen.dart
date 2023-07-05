import 'package:flutter/material.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Report",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: const Center(
        child: Text('Report Screen', style: TextStyle(fontSize: 40)),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:nesteradmin/Models/GrievanceModel.dart';
import 'package:nesteradmin/Provider/EmployService.dart';
import 'package:nesteradmin/Provider/GrievancesProvider.dart';
import 'package:nesteradmin/Screens/Report.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_extend/share_extend.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'dart:html' as html;
import '../../Models/AttendanceModel.dart';
import '../../Models/EmployeeModel.dart';

class AttendanceReports extends StatefulWidget {
  final List<UserAttendance> userattendance;
  final List<Employee> employees;
  const AttendanceReports(
      {Key? key, required this.employees, required this.userattendance})
      : super(key: key);

  @override
  _AttendanceReportsState createState() => _AttendanceReportsState();
}

class _AttendanceReportsState extends State<AttendanceReports> {
  late final pw.Document pdf;
  late final String reportTitle;
  late final List<String> headers;
  late final List<List<String>> data;
  String conclusion(double hours) {
    if (hours >= 8) {
      return 'Execellent';
    } else if (hours >= 7 && hours < 8) {
      return 'Good';
    } else if (hours >= 7 && hours < 8) {
      return 'Average';
    }

    return 'Below Average';
  }

  String username(String uid) {
    var user = widget.employees.firstWhere(
        (element) => element.id.toLowerCase() == uid.toString().toLowerCase());

    return user.name;
  }

  @override
  void initState() {
    super.initState();
    pdf = pw.Document();
    reportTitle = 'Attendance Report';
    headers = ['Employee Name', 'User Id', 'AverageTime(hrs)', 'Remark'];
    data = widget.userattendance
        .map((e) => [
              username(e.userid),
              e.userid,
              e.averagetime,
              conclusion(double.parse(e.averagetime))
            ])
        .toList();
    createPDF();
  }

  void createPDF() {
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          children: [
            pw.Text(reportTitle, style: const pw.TextStyle(fontSize: 40)),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              context: context,
              headers: headers,
              data: data,
            ),
          ],
        ),
      ),
    );
  }

  void savePDF() async {
    final bytes = await pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.window.open(url, '_blank');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            const Text('Download Report'),
            const SizedBox(
              height: 30,
            ),
            IconButton(
              onPressed: savePDF,
              icon: const Icon(Icons.save_alt),
            ),
          ],
        ),
      ),
    );
  }
}

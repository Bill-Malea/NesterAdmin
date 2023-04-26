import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:nesteradmin/Models/GrievanceModel.dart';
import 'package:nesteradmin/Models/leaveModel.dart';
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
import '../../Models/EmployeeModel.dart';

class LeavesReports extends StatefulWidget {
  final List<Leave> leaves;
  const LeavesReports({Key? key, required this.leaves}) : super(key: key);

  @override
  _LeavesReportsState createState() => _LeavesReportsState();
}

class _LeavesReportsState extends State<LeavesReports> {
  late final pw.Document pdf;
  late final String reportTitle;
  late final List<String> headers;
  late final List<List<String>> data;
  String leavestatus(bool? status) {
    if (status == null) {
      return 'Pending';
    } else if (status == true) {
      return 'Approved';
    }
    return 'Denied';
  }

  String datemain(String dateString) {
    // Parse the string to a DateTime object
    DateTime dateTime = DateTime.parse(dateString);

    // Format the DateTime object to a readable date string
    String readableDate = DateFormat('MMMM dd, yyyy').format(dateTime);

    return readableDate; // Output: March 31, 2023
  }

  @override
  void initState() {
    super.initState();
    pdf = pw.Document();
    reportTitle = 'Leaves Report';
    headers = [
      'Name',
      'Leave Reason',
      'Start',
      'End',
      'Status',
    ];
    data = widget.leaves
        .map((e) => [
              e.name,
              e.reason,
              datemain(e.from),
              datemain(e.to),
              leavestatus(e.status),
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

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
import '../../Models/EmployeeModel.dart';

class GrievanceReports extends StatefulWidget {
  final List<Grievance> grievances;
  const GrievanceReports({Key? key, required this.grievances})
      : super(key: key);

  @override
  _GrievanceReportsState createState() => _GrievanceReportsState();
}

class _GrievanceReportsState extends State<GrievanceReports> {
  late final pw.Document pdf;
  late final String reportTitle;
  late final List<String> headers;
  late final List<List<String>> data;

  @override
  void initState() {
    super.initState();
    pdf = pw.Document();
    reportTitle = 'Employee Report';
    headers = [
      'Title',
      'Deparment',
      'Employee',
      'Response',
    ];
    data = widget.grievances
        .map((e) =>
            [e.title, e.department, e.username, e.reply ?? 'Not Responded'])
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

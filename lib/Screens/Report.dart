import 'package:flutter/material.dart';
import 'package:nesteradmin/Provider/EmployService.dart';
import 'package:nesteradmin/Provider/GrievancesProvider.dart';
import 'package:nesteradmin/Screens/Reports/EmployeReport.dart';
import 'package:nesteradmin/Screens/Reports/GrievancesReports.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'dart:html' as html;

import 'package:provider/provider.dart';

class PDFSave extends StatefulWidget {
  final String title;

  const PDFSave({super.key, required this.title});
  @override
  _PDFSaveState createState() => _PDFSaveState();
}

class _PDFSaveState extends State<PDFSave> {
  @override
  Widget build(BuildContext context) {
    var employess = Provider.of<EmployProvider>(context).employees;
    var grievances = Provider.of<GrievanceProvider>(context).grievances;
    return Container(
      margin: const EdgeInsets.all(50),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EmployeeReports(
                          employees: employess,
                        )),
              );
            },
            child: Row(
              children: const [
                Text('Employee Report'),
                SizedBox(
                  width: 50,
                ),
                Icon(
                  Icons.download,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EmployeeReports(
                          employees: employess,
                        )),
              );
            },
            child: Row(
              children: const [
                Text('Grievances Report'),
                SizedBox(
                  width: 50,
                ),
                Icon(
                  Icons.download,
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GrievanceReports(
                          grievances: grievances,
                        )),
              );
            },
            child: Row(
              children: const [
                Text('Leaves Report'),
                SizedBox(
                  width: 50,
                ),
                Icon(
                  Icons.download,
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EmployeeReports(
                          employees: employess,
                        )),
              );
            },
            child: Row(
              children: const [
                Text('Attendance Report'),
                SizedBox(
                  width: 50,
                ),
                Icon(
                  Icons.download,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

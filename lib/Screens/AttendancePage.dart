import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nesteradmin/Models/EmployeeModel.dart';
import 'package:nesteradmin/Provider/AttendanceProvider.dart';
import 'package:nesteradmin/Provider/EmployService.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class AttendancePerformancePage extends StatefulWidget {
  @override
  _AttendancePerformancePageState createState() =>
      _AttendancePerformancePageState();
}

class _AttendancePerformancePageState extends State<AttendancePerformancePage> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AttendanceProvider>(context, listen: false).fetchAttendance();
      Provider.of<EmployProvider>(context, listen: false).fetchEmployees();
    });
  }

  @override
  Widget build(BuildContext context) {
    var employees = Provider.of<EmployProvider>(context).employees;
    var attendance = Provider.of<AttendanceProvider>(context).attendance;

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

    Color progressColor(double hours) {
      if (hours >= 8) {
        return Colors.green;
      } else if (hours >= 7 && hours < 8) {
        return Colors.greenAccent;
      } else if (hours >= 7 && hours < 8) {
        return const Color.fromARGB(255, 207, 165, 12);
      }

      return Colors.red;
    }

    return Scaffold(
      body: attendance.isEmpty && employees.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
              strokeWidth: 1,
            ))
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                dataRowHeight: 70,
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Department')),
                  DataColumn(label: Text('Role')),
                  DataColumn(label: Text('Average Hours')),
                  DataColumn(label: Text('Percentage')),
                  DataColumn(label: Text('Conclusion')),
                ],
                rows: attendance.map((att) {
                  var emp = employees.firstWhere((e) => e.id == att.userid);

                  var average = (double.parse(att.averagetime) / 8);
                  return DataRow(cells: [
                    DataCell(Text(emp.name)),
                    DataCell(Text(emp.department)),
                    DataCell(Text(emp.role)),
                    DataCell(Text(att.averagetime)),
                    DataCell(CircularPercentIndicator(
                      radius: 30.0,
                      lineWidth: 7.0,
                      percent: average,
                      center: Text(
                        '${(average * 100).toStringAsFixed(2)}%',
                        style: const TextStyle(fontSize: 10),
                      ),
                      progressColor: progressColor(average),
                    )),
                    DataCell(
                      Text(conclusion(average)),
                    ),
                  ]);
                }).toList(),
              ),
            ),
    );
  }
}

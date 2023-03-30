import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nesteradmin/Models/EmployeeModel.dart';
import 'package:nesteradmin/Provider/AttendanceProvider.dart';
import 'package:nesteradmin/Provider/EmployService.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    var employees = Provider.of<EmployProvider>(context).employees;
    var attendance = Provider.of<AttendanceProvider>(context).attendance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Performance'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Department')),
                  DataColumn(label: Text('Role')),
                  DataColumn(label: Text('Average Hours')),
                 
                ],
                rows: attendance.map((att) {
                  var emp = employees.firstWhere((e) => e.id == att.userid);

                  var average = (double.parse(att.averagetime) / 8) * 100;
                  return DataRow(cells: [
                    DataCell(Text(emp.name)),
                    DataCell(Text(emp.department)),
                    DataCell(Text(emp.role)),
                    DataCell(Text('${average.toStringAsFixed(2)}%')),
                  
                  ]);
                }).toList(),
              ),
            ),
    );
  }
}

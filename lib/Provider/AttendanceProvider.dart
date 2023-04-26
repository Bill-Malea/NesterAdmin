import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nesteradmin/Models/AttendanceModel.dart';

class AttendanceProvider extends ChangeNotifier {
  final apiUrl = 'https://nester-fee8e-default-rtdb.firebaseio.com';
  List<UserAttendance> _attendance = [];
  List<UserAttendance> get attendance => _attendance;

  Future<List<UserAttendance>?> fetchAttendance() async {
    final response = await http.get(Uri.parse('$apiUrl/Attendance.json'));
    var dataraw = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var data = dataraw as Map<String, dynamic>;

      List<UserAttendance> rawdata = [];
      data.forEach((key, value) {
        var val = value as Map<String, dynamic>;
        List<Attendance> rawatt = [];

        int totalTime = 0;
        int numEntries = 0;

        val.forEach((attid, att) {
          if (att['checkout'] != null) {
            var checkin = DateTime.parse(att['checkin']);
            var checkout = DateTime.parse(att['checkout']);

            int diffInMinutes = checkout.difference(checkin).inHours;
            totalTime += diffInMinutes;

            numEntries++;

            rawatt.add(Attendance(checkin: checkin, checkout: checkout));
          }
        });

        var averageTime = totalTime / numEntries;

        rawdata.add(UserAttendance(
          userid: key,
          attendancelist: rawatt,
          averagetime: averageTime.toStringAsFixed(2),
        ));
      });

      _attendance = rawdata;
      notifyListeners();
      return rawdata;
    } else {
      throw Exception('Failed to fetch attendance data');
    }
  }
}

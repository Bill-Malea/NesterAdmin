import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nesteradmin/Models/AttendanceModel.dart';

class AttendanceProvider extends ChangeNotifier {
  final apiUrl = '';
  List<UserAttendance> _attendance = [];
  List<UserAttendance> get attendance => _attendance;

  Future<List<UserAttendance>?> fetchAttendance() async {
    final response = await http.get(Uri.parse('$apiUrl/Attendance.json'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as Map<String, dynamic>;
      List<UserAttendance> rawdata = [];
      data.forEach((key, value) {
        var val = value as Map<String, dynamic>;
        List<Attendance> rawatt = [];

        int totalTime = 0;
        int numEntries = 0;

        val.forEach((attid, att) {
          var checkin = DateTime.parse(att['checkin']);
          var checkout = DateTime.parse(att['checkout']);

          int diffInMinutes = checkout.difference(checkin).inMinutes;
          totalTime += diffInMinutes;
          numEntries++;

          rawatt.add(Attendance(checkin: checkin, checkout: checkout));
        });

        var averageTime = totalTime / numEntries;
        var formattedTime =
            '${(averageTime / 60).floor()}:${(averageTime % 60).toString().padLeft(2, '0')}';

        rawdata.add(UserAttendance(
          userid: key,
          attendancelist: rawatt,
          averagetime: formattedTime,
        ));
      });
      _attendance = rawdata;
      return rawdata;
    } else {
      throw Exception('Failed to fetch attendance data');
    }
  }
}

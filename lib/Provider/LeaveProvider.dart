import 'dart:convert';
import 'package:flutter/material.dart';
import '../Models/leaveModel.dart';
import 'package:http/http.dart' as http;

class LeaveProvider extends ChangeNotifier {
  List<Leave> _leaves = [];
  List<Leave> get leaves => [..._leaves];
  Future<List<Leave>> fetchLeaves() async {
    final response = await http.get(Uri.parse(
        'https://employee-management-syst-29f9f-default-rtdb.firebaseio.com/Leave.json'));
    var rawdata = jsonDecode(response.body);
    List<Leave> leaves = [];
    if (response.statusCode == 200 && rawdata != null) {
      var data = rawdata as Map<String, dynamic>;
      data.forEach((key, value) {
        var val = value as Map<String, dynamic>;
        val.forEach((id, leave) {
          leaves.add(Leave(
            supportDocuments: leave['supportDoc'],
            id: id,
            employid: key,
            name: leave['reason'],
            from: leave['from'],
            to: leave['to'],
            reason: leave['reason'],
            status: leave['status'],
          ));
        });
      });
      _leaves = leaves;
      notifyListeners();
      return leaves;
    } else {
      throw Exception('Failed to fetch leaves');
    }
  }

  Future<bool> approveLeave(Leave leave) async {
    var employid = leave.employid;
    var leaveid = leave.id;
    var body = {
      'status': true,
      'denialreason': null,
    };

    final response = await http.patch(
        Uri.parse(
          'https://employee-management-syst-29f9f-default-rtdb.firebaseio.com/Leave/$employid/$leaveid.json',
        ),
        body: jsonEncode(body));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to fetch leaves');
    }
  }

  Future<bool> denyLeave(Leave leave, String denialreason) async {
    var employid = leave.employid;
    var leaveid = leave.id;
    var body = {
      'status': false,
      'denialreason': denialreason,
    };

    final response = await http.patch(
        Uri.parse(
          'https://employee-management-syst-29f9f-default-rtdb.firebaseio.com/Leave/$employid/$leaveid.json',
        ),
        body: jsonEncode(body));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to fetch leaves');
    }
  }
}

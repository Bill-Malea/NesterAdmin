import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nesteradmin/Models/GrievanceModel.dart';
import 'package:http/http.dart' as http;

class GrievanceProvider extends ChangeNotifier {
  List<Grievance> _grievances = [];

  List<Grievance> get grievances => [..._grievances];
  Future<List<Grievance>> fetchGrieves() async {
    final response = await http.get(Uri.parse(
        'https://nester-fee8e-default-rtdb.firebaseio.com/Grievances.json'));
    var rawdata = jsonDecode(response.body);
    List<Grievance> grievance = [];
    List<Grievance> allgrievance = [];
    if (response.statusCode == 200 && rawdata != null) {
      var data = rawdata as Map<String, dynamic>;
      data.forEach((key, value) {
        var val = value as Map<String, dynamic>;
        val.forEach((id, griev) {
          String? hasreply = griev['reply'];
          if (hasreply == null) {
            grievance.add(
              Grievance(
                id: id,
                dateTime: griev['datetime'],
                department: griev['description'],
                reply: griev['reply'],
                title: griev['title'],
                userid: key,
                username: '',
                description: griev['description'],
              ),
            );
          }

          allgrievance.add(
            Grievance(
              id: id,
              dateTime: griev['datetime'],
              department: griev['description'],
              reply: griev['reply'],
              title: griev['title'],
              userid: key,
              username: '',
              description: griev['description'],
            ),
          );
          _grievances = allgrievance;
          notifyListeners();
        });
      });

      return grievance;
    } else {
      throw Exception('Failed to fetch leaves');
    }
  }

  Future<bool> reply(Grievance griev, String reply) async {
    var id = griev.userid;
    var grievid = griev.id;
    var body = {
      'reply': reply,
    };

    final response = await http.patch(
        Uri.parse(
          'https://nester-fee8e-default-rtdb.firebaseio.com/Grievances/$id/$grievid.json',
        ),
        body: jsonEncode(body));

    if (response.statusCode == 200) {
      await fetchGrieves();
      return true;
    } else {
      throw Exception('Failed to Update Grievances');
    }
  }
}

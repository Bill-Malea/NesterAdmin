import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Models/ResignationModel.dart';

class ResignationProvider extends ChangeNotifier {
  List<Resignation> _resignation = [];
  List<Resignation> get resignation => _resignation;

  Future<void> fetchResigns() async {
    final response = await http.get(Uri.parse(
        'https://nester-fee8e-default-rtdb.firebaseio.com/Resignation.json'));
    var rawdata = jsonDecode(response.body);
    List<Resignation> resigns = [];
    if (response.statusCode == 200 && rawdata != null) {
      var data = rawdata as Map<String, dynamic>;
      data.forEach((key, value) {
        var val = value as Map<String, dynamic>;
        val.forEach((id, resgn) {
          String? status = resgn['status'];
          if (status == null) {
            resigns.add(Resignation(
                id: id,
                reason: resgn['reason'],
                status: resgn['status'],
                userid: key));
          }
        });
      });

      _resignation = resigns;
      notifyListeners();
    } else {
      throw Exception('Failed to fetch leaves');
    }
  }

  Future<List<Resignation>> updateResigns() async {
    final response = await http.get(Uri.parse(
        'https://nester-fee8e-default-rtdb.firebaseio.com/Resignation.json'));
    var rawdata = jsonDecode(response.body);
    List<Resignation> resigns = [];
    if (response.statusCode == 200 && rawdata != null) {
      var data = rawdata as Map<String, dynamic>;
      data.forEach((key, value) {
        var val = value as Map<String, dynamic>;
        val.forEach((id, resgn) {
          String? status = resgn['status'];
          if (status == null) {
            resigns.add(Resignation(
                id: id,
                reason: resgn['reason'],
                status: resgn['status'],
                userid: key));
          }
        });
      });

      return resigns;
    } else {
      throw Exception('Failed to fetch leaves');
    }
  }
}

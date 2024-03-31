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

  Future<bool> deletresign(
    String id,
    BuildContext context,
  ) async {
    final response = await http.delete(
      Uri.parse(
          'https://nester-fee8e-default-rtdb.firebaseio.com/Resignation/$id.json'),
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as Map<String, dynamic>;
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return SizedBox(
            height: 300,
            child: AlertDialog(
              title: const Text('Success'),
              content: const SizedBox(
                height: 200,
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle_outline_outlined,
                      color: Colors.greenAccent,
                      size: 50,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('User  Deleted Successfully  '),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Close'),
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                ),
              ],
            ),
          );
        },
      );
      return response.statusCode == 200;
    } else {
      throw Exception('Failed to create employee');
    }
  }
}

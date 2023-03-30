import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../Models/EmployeeModel.dart';

class EmployProvider extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _baseUrl = 'https://nester-fee8e-default-rtdb.firebaseio.com';

  List<Employee> _employess = [];

  List<Employee> get employees => [..._employess];

  employtoJson(Employee employee) {
    return {
      'role': employee.role,
      'id': employee.id,
      'name': employee.name,
      'email': employee.email,
      'phone': employee.phone,
      'department': employee.department,
      'gender': employee.gender,
      'joineDate': DateTime.now().toIso8601String(),
      'salary': employee.salary,
    };
  }

  Future<User?> createUser(String email, BuildContext ctx) async {
    UserCredential userCredential;
    try {
      userCredential = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: '1234567890');

      return userCredential.user;
    } on PlatformException catch (err) {
      var message = "An error occured please check your credentails";

      if (err.message != null) {
        message = err.message!;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ));
    } catch (err) {
      // ignore: avoid_print
    }
    return null;
  }

  Future<List<Employee>> fetchEmployees() async {
    final response = await http.get(Uri.parse('$_baseUrl/Employees.json'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as Map<String, dynamic>;
      List<Employee> fetchedemp = [];
      jsonData.forEach((key, value) {
        value.forEach((dbid, val) {
          fetchedemp.add(Employee(
            dbid: dbid,
            role: val['role'] ?? '',
            id: key,
            name: val['name'] ?? '',
            email: val['email'] ?? '',
            phone: val['phone'] ?? '',
            department: val['department'] ?? '',
            gender: val['gender'] ?? '',
            joineDate: val['joinDate'] ?? '',
            salary: val['salary'] ?? '',
          ));
        });
      });
      _employess = fetchedemp;
      notifyListeners();
      return fetchedemp;
    } else {
      throw Exception('Failed to load employees');
    }
  }

  Future<Employee?> createEmployee(
      dynamic employee, String id, BuildContext context) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/Employees/$id/.json'),
      body: json.encode(employee),
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
              content: Column(
                children: [
                  const Icon(
                    Icons.check_circle_outline_outlined,
                    color: Colors.greenAccent,
                    size: 50,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text('User ${jsonData['name']} Created Successfully  '),
                ],
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
      return Employee.fromJson(jsonData);
    } else {
      throw Exception('Failed to create employee');
    }
  }

  Future<void> updateEmployee(Employee employee) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/Employees/${employee.id}.json'),
      body: json.encode(employtoJson(employee)),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update employee');
    }
  }

  Future<void> deleteEmployee(String id) async {
    final response =
        await http.delete(Uri.parse('$_baseUrl/Employees/$id.json'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete employee');
    }
  }
}

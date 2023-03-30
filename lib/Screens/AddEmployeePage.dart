import 'package:flutter/material.dart';
import 'package:nesteradmin/Provider/EmployService.dart';
import 'package:provider/provider.dart';

class AddEmployPage extends StatefulWidget {
  const AddEmployPage({super.key});

  @override
  _AddEmployPageState createState() => _AddEmployPageState();
}

class _AddEmployPageState extends State<AddEmployPage> {
  final _formKey = GlobalKey<FormState>();
  final _data = <String, String>{};
  bool creatingUser = false;
  bool addingData = false;
  void creatingEmployee() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        creatingUser = true;
      });
      Provider.of<EmployProvider>(context, listen: false)
          .createUser(_data['email']!, context)
          .then((value) {
        if (value != null) {
          Provider.of<EmployProvider>(context, listen: false).createEmployee({
            'id': value.uid,
            'name': _data['name'],
            'email': _data['email'],
            'phone': _data['phone'],
            'gender': _data['gender'],
            'department': _data['department'],
            'salary': _data['salary'],
            'role': _data['role'],
            'joinDate': DateTime.now().toString()
          }, value.uid, context).then((_) {
            setState(() {
              creatingUser = false;
              addingData = false;
            });
          });
        } else {
          setState(() {
            creatingUser = false;
            addingData = false;
          });
          showDialog(
              context: context,
              builder: (BuildContext ctx) {
                return SizedBox(
                  height: 300,
                  child: AlertDialog(
                    title: const Text('Failed To Create User'),
                    content: Column(
                      children: const [
                        Icon(
                          Icons.dangerous,
                          color: Colors.red,
                          size: 35,
                        ),
                        Text('Failed to Create User '),
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
              });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Employee'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: creatingUser
              ? Column(
                  children: [
                    if (!addingData)
                      const CircularProgressIndicator(
                        strokeWidth: 1,
                      ),
                    if (addingData)
                      Row(
                        children: const [
                          CircularProgressIndicator(
                            strokeWidth: 1,
                          ),
                          SizedBox(width: 10),
                          Text('Adding User Data..........')
                        ],
                      ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildInputField('Name', 'name'),
                            _buildInputField('Email', 'email'),
                            _buildInputField('Phone', 'phone'),
                            _buildInputField('Gender', 'gender'),
                            _buildInputField('Department', 'department'),
                            _buildInputField('Salary', 'salary'),
                            _buildInputField('Role', 'role'),
                            SizedBox(
                              width: 250,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: creatingEmployee,
                                child: const Text('Save'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String key) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.0),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
        onChanged: (value) {
          setState(() {
            _data[key] = value;
          });
        },
        onSaved: (value) {
          _data[key] = value!;
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ResignationPage extends StatefulWidget {
  @override
  _ResignationPageState createState() => _ResignationPageState();
}

class _ResignationPageState extends State<ResignationPage> {
  List<Map<String, dynamic>> resignations = [
    {'name': 'Alice', 'reason': 'Moving to a new city', 'approved': false},
    {'name': 'Bob', 'reason': 'Starting a new job', 'approved': false},
    {'name': 'Charlie', 'reason': 'Family emergency', 'approved': false},
  ];

  void _approveResignation(int index) {
    setState(() {
      resignations[index]['approved'] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: resignations.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: const Icon(Icons.person),
            title: Text(resignations[index]['name']),
            subtitle: Text(resignations[index]['reason']),
            trailing: IconButton(
              icon: const Icon(Icons.check),
              onPressed: resignations[index]['approved']
                  ? null
                  : () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Approve Resignation?'),
                            content: const Text(
                                'Are you sure you want to approve this resignation request?'),
                            actions: [
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                child: const Text('Approve'),
                                onPressed: () {
                                  _approveResignation(index);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

class GrievancesPage extends StatefulWidget {
  @override
  _GrievancesPageState createState() => _GrievancesPageState();
}

class _GrievancesPageState extends State<GrievancesPage> {
  List<Map<String, dynamic>> grievances = [
    {
      'name': 'Alice',
      'date': 'March 1, 2023',
      'description': 'I was not paid for my overtime work'
    },
    {
      'name': 'Bob',
      'date': 'March 10, 2023',
      'description': 'I was unfairly denied a promotion'
    },
    {
      'name': 'Charlie',
      'date': 'March 15, 2023',
      'description': 'I was harassed by a co-worker'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Grievances'),
      ),
      body: ListView.builder(
        itemCount: grievances.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(grievances[index]['name']),
              subtitle: Text(grievances[index]['date']),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Grievance Details'),
                        content: Text(grievances[index]['description']),
                        actions: [
                          TextButton(
                            child: const Text('Close'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

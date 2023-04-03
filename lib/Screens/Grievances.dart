import 'package:flutter/material.dart';
import 'package:nesteradmin/Models/GrievanceModel.dart';
import 'package:nesteradmin/Provider/EmployService.dart';
import 'package:nesteradmin/Provider/GrievancesProvider.dart';
import 'package:provider/provider.dart';

class GrievancesPage extends StatefulWidget {
  @override
  _GrievancesPageState createState() => _GrievancesPageState();
}

class _GrievancesPageState extends State<GrievancesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EmployProvider>(context, listen: false).fetchEmployees();
    });
  }

  var _reply = '';
  var isloading = false;
  @override
  Widget build(BuildContext context) {
    var employees = Provider.of<EmployProvider>(context).employees;
    return Scaffold(
      body: isloading && employees.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
              strokeWidth: 1,
            ))
          : FutureBuilder<List<Grievance>>(
              future: Provider.of<GrievanceProvider>(context).fetchGrieves(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<Grievance> grievance = snapshot.data!;

                  return ListView.builder(
                    itemCount: grievance.length,
                    itemBuilder: (BuildContext context, int index) {
                      final empname = employees
                          .where((element) =>
                              element.id == grievance[index].userid)
                          .first;

                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(empname.name),
                          subtitle: Text(grievance[index].department),
                          trailing: IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Grievance Details'),
                                    content: SizedBox(
                                      height: 200,
                                      child: Column(
                                        children: [
                                          Text(grievance[index].description!),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          _buildInputField('Grievance Response')
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: const Text('Upload'),
                                        onPressed: () {
                                          Navigator.pop(context);

                                          if (_reply.isNotEmpty) {
                                            setState(() {
                                              isloading = true;
                                            });
                                            Provider.of<GrievanceProvider>(
                                                    context,
                                                    listen: false)
                                                .reply(grievance[index], _reply)
                                                .whenComplete(() {
                                              setState(() {
                                                isloading = false;
                                              });
                                            });
                                          }
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
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return const Center(
                      child: CircularProgressIndicator(
                    strokeWidth: 1,
                  ));
                }
              },
            ),
    );
  }

  Widget _buildInputField(
    String label,
  ) {
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
            return 'Please Denial Reason';
          }
          return null;
        },
        onChanged: (value) {
          setState(() {
            _reply = value;
          });
        },
      ),
    );
  }
}

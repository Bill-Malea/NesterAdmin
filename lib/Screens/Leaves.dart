import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nesteradmin/Provider/LeaveProvider.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import '../Models/leaveModel.dart';

class LeavesPage extends StatefulWidget {
  const LeavesPage({super.key});

  @override
  _LeavesPageState createState() => _LeavesPageState();
}

class _LeavesPageState extends State<LeavesPage> {
  var isloading = false;
  var _denialreason = '';
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Leave>>(
      future: Provider.of<LeaveProvider>(context).fetchLeaves(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<Leave> leaves = snapshot.data!;
          final List<Leave> appliedLeaves =
              leaves.where((leave) => leave.status == null).toList();

          final List<Leave> approvedLeaves =
              leaves.where((leave) => leave.status == true).toList();

          final List<Leave> deniedLeaves =
              leaves.where((leave) => leave.status == false).toList();

          return DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Leaves'),
                centerTitle: true,
                bottom: const TabBar(
                  tabs: [
                    Tab(text: 'Applied'),
                    Tab(text: 'Approved'),
                    Tab(text: 'Denied'),
                  ],
                ),
              ),
              body: isloading
                  ? Center(
                      child: Column(
                        children: const [
                          CircularProgressIndicator(
                            strokeWidth: 1,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Processing')
                        ],
                      ),
                    )
                  : TabBarView(
                      children: [
                        _buildLeavesList(appliedLeaves),
                        _buildLeavesList(approvedLeaves),
                        _buildLeavesList(deniedLeaves),
                      ],
                    ),
            ),
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
            _denialreason = value;
          });
        },
      ),
    );
  }

  Widget _buildLeavesList(List<Leave> leaves) {
    return ListView.builder(
      itemCount: leaves.length,
      itemBuilder: (context, index) {
        final leave = leaves[index];
        final to =
            '${DateTime.parse(leave.to).year.toString()}-${DateTime.parse(leave.to).month.toString()}-${DateTime.parse(leave.to).day.toString()}';
        final from =
            '${DateTime.parse(leave.from).year.toString()}-${DateTime.parse(leave.from).month.toString()}-${DateTime.parse(leave.from).day.toString()}';
        return ListTile(
          title: Text(leave.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('From: $from'),
              const SizedBox(
                height: 20,
              ),
              Text('To: $to'),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {},
          ),
          onTap: () {
            if (leave.status == null) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Leave details'),
                  content: Column(
                    children: [
                      Text(leave.reason),
                      SizedBox(
                          height: 300,
                          width: 400,
                          child: Image.network(leave.supportDocuments)),
                      const SizedBox(
                        height: 10,
                      ),
                      _buildInputField('Denial Reason')
                    ],
                  ),
                  actions: [
                    TextButton(
                      child: const Text('Deny'),
                      onPressed: () {
                        if (_denialreason.isNotEmpty) {
                          Navigator.of(context).pop();
                          setState(() {
                            isloading = true;
                          });
                          Provider.of<LeaveProvider>(context, listen: false)
                              .denyLeave(leave, _denialreason)
                              .whenComplete(() {
                            setState(() {
                              isloading = false;
                            });
                          });
                        } else {}
                      },
                    ),
                    TextButton(
                      child: const Text('Approve'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          isloading = true;
                        });
                        Provider.of<LeaveProvider>(context, listen: false)
                            .approveLeave(leave)
                            .whenComplete(() {
                          setState(() {
                            isloading = false;
                          });
                        });
                      },
                    ),
                  ],
                ),
              );
            }
          },
        );
      },
    );
  }
}

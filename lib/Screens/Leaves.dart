import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Models/leaveModel.dart';

class LeavesPage extends StatefulWidget {
  const LeavesPage({super.key});

  @override
  _LeavesPageState createState() => _LeavesPageState();
}

class _LeavesPageState extends State<LeavesPage> {
  late Future<List<Leave>> _leavesFuture;

  @override
  void initState() {
    super.initState();
    _leavesFuture = _fetchLeaves();
  }

  Future<List<Leave>> _fetchLeaves() async {
    final response = await http.get(Uri.parse('https://example.com/leaves'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      final List<Leave> leaves = Leave.fromJsonList(jsonList);
      return leaves;
    } else {
      throw Exception('Failed to fetch leaves');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Leave>>(
      future: _leavesFuture,
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
                bottom: const TabBar(
                  tabs: [
                    Tab(text: 'Applied'),
                    Tab(text: 'Approved'),
                    Tab(text: 'Denied'),
                  ],
                ),
              ),
              body: TabBarView(
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

  Widget _buildLeavesList(List<Leave> leaves) {
    return ListView.builder(
      itemCount: leaves.length,
      itemBuilder: (context, index) {
        final leave = leaves[index];
        return ListTile(
          title: Text(leave.name),
          subtitle: Text(leave.dateRange),
          trailing: IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // TODO: Implement approve leave
            },
          ),
          onTap: () {
            if (leave.status == null) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Leave details'),
                  content: Text(leave.reason),
                  actions: [
                    TextButton(
                      child: const Text('Close'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    // ignore: unnecessary_null_comparison
                    if (leave.supportDocuments != null)
                      TextButton(
                        child: const Text('View documents'),
                        onPressed: () {
                          // TODO: Implement view documents
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

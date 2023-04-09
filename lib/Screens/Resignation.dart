import 'package:flutter/material.dart';
import 'package:nesteradmin/Provider/EmployService.dart';
import 'package:nesteradmin/Provider/ResignationProvider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ResignationPage extends StatefulWidget {
  @override
  _ResignationPageState createState() => _ResignationPageState();
}

class _ResignationPageState extends State<ResignationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ResignationProvider>(context, listen: false).fetchResigns();
    });
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    var resignations = Provider.of<ResignationProvider>(context).resignation;
    var employess = Provider.of<EmployProvider>(context).employees;
    sendresignationemail(String email, dynamic employee, employeid) async {
      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: email,
        query: encodeQueryParameters(<String, String>{
          'subject': 'Resignation Request',
        }),
      );
      var succesded = await Provider.of<EmployProvider>(context, listen: false)
          .archiveEmployee(employee, context, employeid)
          .then((value) {
        if (value) {
          Provider.of<EmployProvider>(context, listen: false)
              .deleteEmployee(employeid, context)
              .then((value) {
            if (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Successfully Deleted.'),
                    backgroundColor: Colors.green),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to Delete Files.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to Archive  Files.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      });

      // ignore: use_build_context_synchronously
      await Provider.of<ResignationProvider>(context)
          .deletresign(employeid, context);
      bool didlauch = await launchUrl(
        emailLaunchUri,
      );
    }

    return resignations.isEmpty
        ? Center(
            child: Column(
              children: const [Text('No Resignation Requests')],
            ),
          )
        : Container(
            padding: const EdgeInsets.all(10),
            child: ListView.builder(
              itemCount: resignations.length,
              itemBuilder: (BuildContext context, int index) {
                var employ = employess
                    .where(
                        (element) => element.id == resignations[index].userid)
                    .first;
                var employjson = {
                  'role': employ.role,
                  'id': employ.id,
                  'name': employ.name,
                  'email': employ.email,
                  'phone': employ.phone,
                  'department': employ.department,
                  'gender': employ.gender,
                  'joineDate': employ.joineDate,
                  'salary': employ.salary,
                };
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(employ.name),
                  subtitle: Text(resignations[index].reason),
                  trailing: IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () {
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
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await sendresignationemail(
                                      employ.email, employjson, employ.id);
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

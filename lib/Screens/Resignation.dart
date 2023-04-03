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
    sendresignationemail(String email) async {
      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: email,
        query: encodeQueryParameters(<String, String>{
          'subject': 'Resignation Request',
        }),
      );
      await launchUrl
      (emailLaunchUri, );
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
                                  await sendresignationemail(employ.email);
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

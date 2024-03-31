import 'package:flutter/material.dart';
import 'package:nesteradmin/Provider/EmployService.dart';
import 'package:nesteradmin/Provider/LeaveProvider.dart';
import 'package:provider/provider.dart';

import '../Models/EmployeeModel.dart';
import 'AddEmployeePage.dart';

class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EmployeeListPageState createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  var isloading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isloading = true;
      Provider.of<EmployProvider>(context, listen: false)
          .fetchEmployees()
          .then((value) {
        setState(() {
          isloading = false;
        });
      });
      Provider.of<LeaveProvider>(context, listen: false).fetchLeaves();
    });
  }

  @override
  Widget build(BuildContext context) {
    var employees = Provider.of<EmployProvider>(
      context,
    ).employees;
    return SingleChildScrollView(
      child: isloading
          ? const Center(
              child: CircularProgressIndicator(
                strokeWidth: 1,
              ),
            )
          : Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 160,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddEmployPage(
                                    employee: Employee(
                                      dbid: '',
                                      department: '',
                                      gender: '',
                                      id: '',
                                      name: '',
                                      email: '',
                                      phone: '',
                                      role: '',
                                      salary: '',
                                      joineDate: '',
                                    ),
                                  )),
                        );
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.person_add_alt_rounded),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Add Employee',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DataTable(
                    columns: const [
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Gender')),
                      DataColumn(label: Text('Department')),
                      DataColumn(label: Text('Role')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Phone')),
                      DataColumn(label: Text('Salary')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: employees.map((employee) {
                      return DataRow(cells: [
                        DataCell(Text(employee.name)),
                        DataCell(Text(employee.gender)),
                        DataCell(Text(employee.department)),
                        DataCell(Text(employee.role)),
                        DataCell(Text(employee.email)),
                        DataCell(Text(employee.phone)),
                        DataCell(Text(employee.salary)),
                        DataCell(
                          PopupMenuButton(
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry>[
                              const PopupMenuItem(
                                value: 'modify',
                                child: Text('Modify'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                            onSelected: (value) {
                              if (value.toString().toLowerCase() == 'modify') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddEmployPage(
                                            employee: employee,
                                          )),
                                );
                              } else if (value.toString().toLowerCase() ==
                                  'delete') {
                                Provider.of<EmployProvider>(context,
                                        listen: false)
                                    .deleteEmployee(employee.id, context);
                              }
                            },
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ],
              ),
            ),
    );
  }
}

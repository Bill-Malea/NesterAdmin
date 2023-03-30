import 'package:flutter/material.dart';
import 'Screens/AttendancePage.dart';
import 'Screens/EmployesList.dart';
import 'Screens/Grievances.dart';
import 'Screens/Leaves.dart';
import 'Screens/Resignation.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const EmployeeListPage(),
    AttendancePerformancePage(),
    const LeavesPage(),
    GrievancesPage(),
    ResignationPage(),

    // Add additional pages as necessary
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String getHeader() {
    if (_selectedIndex == 1) {
      return 'Attendance Reports';
    } else if (_selectedIndex == 2) {
      return 'Leaves';
    } else if (_selectedIndex == 3) {
      return 'Grievances';
    } else if (_selectedIndex == 4) {
      return 'Resignation List';
    }
    return 'Employee Management Interface';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      appBar: _selectedIndex == 2
          ? null
          : AppBar(
              title: Text(getHeader()),
              centerTitle: true,
            ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
            ),
            label: 'Employee List',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.bar_chart,
            ),
            label: 'Attendance Performance',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.time_to_leave,
            ),
            label: 'Leave',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.cyclone_rounded,
            ),
            label: 'Grievances',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.close,
            ),
            label: 'Resignation',
          ),
          // Add additional items as necessary
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

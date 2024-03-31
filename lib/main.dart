import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nesteradmin/Provider/AttendanceProvider.dart';
import 'package:nesteradmin/Provider/EmployService.dart';
import 'package:nesteradmin/Provider/GrievancesProvider.dart';
import 'package:nesteradmin/Provider/LeaveProvider.dart';
import 'package:nesteradmin/Provider/ResignationProvider.dart';
import 'package:provider/provider.dart';
import 'NavBar.dart';
import 'Provider/NavigationProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBkeALt7zNfaV2EzcXebRffCuL6dL9ENvw",
      appId: "employee-management-syst-29f9f",
      messagingSenderId: "XXX",
      projectId: "employee-management-syst-29f9f",
    ),
  );
  runApp(MultiProvider(
      key: ObjectKey(DateTime.now().toString()),
      providers: [
        ChangeNotifierProvider(
          create: (context) => NavProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => EmployProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AttendanceProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LeaveProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => GrievanceProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ResignationProvider(),
        ),
      ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NESTER ADMIN',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(background: Colors.black)
              .copyWith(secondary: const Color(0xFF3a424d))
              .copyWith(primary: const Color.fromARGB(255, 88, 230, 112))),
      home: const Navigation(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EMPLOYEE ATTENDANCE MANAGEMENT SYSTEM'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Welcome to the Employee Management Interface!'),
      ),
    );
  }
}

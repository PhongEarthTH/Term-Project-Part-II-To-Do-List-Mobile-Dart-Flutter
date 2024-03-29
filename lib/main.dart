import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/login.dart';
import 'screens/taskform.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Users CRUD',
      initialRoute: '/',
      routes: {
        '/': (context) => const HOME(),
        '/login': (context) => const Login(),
        '/Task': (context) => const taskfrompage(),

      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:proj_sqflite/screens/add_note.dart';
import 'package:proj_sqflite/screens/edit_note.dart';

import 'screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'AddNote': (context) => const AddNote(),
        'EditNote': (context) => const EditNote(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.indigo,
        useMaterial3: true,
      ),
      title: 'sqflite Course',
      home: const Home(),
    );
  }
}

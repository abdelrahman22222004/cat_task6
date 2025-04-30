import 'package:flutter/material.dart';
import 'package:sql/add_note.dart';
import 'package:sql/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        "addnotes": (context) => const AddNotes()
      }, // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

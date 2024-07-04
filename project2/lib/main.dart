// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:project2/Classes.dart';
import 'package:project2/HomePage.dart';
import 'package:project2/ToDo.dart';
import 'package:project2/navigation.dart';
import 'package:project2/pages.dart/Login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Amozeshyar",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: login(),
    );
  }
}

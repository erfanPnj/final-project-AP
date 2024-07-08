// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:project2/Classes.dart';
import 'package:project2/HomePage.dart';
import 'package:project2/News.dart';
import 'package:project2/ToDo.dart';
import 'package:project2/flutter_local_notification.dart';
import 'package:project2/navigation.dart';
import 'package:project2/pages.dart/Login.dart';
import 'package:project2/profile.dart';
import 'package:project2/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();
  runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(), child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: Provider.of<ThemeProvider>(context).themeData,
        debugShowCheckedModeBanner: false,
        title: "Amozeshyar",
        home: login());
  }
}

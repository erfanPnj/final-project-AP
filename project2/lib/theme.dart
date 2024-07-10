// import 'package:flutter/material.dart';

// ThemeData light =
//     ThemeData(primarySwatch: Colors.blue, brightness: Brightness.light);

// ThemeData dark =
//     ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark);

import 'package:flutter/material.dart';

// Light theme data
ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  // appBarTheme: AppBarTheme(
  //   color: Colors.blue,
  //   brightness: Brightness.light,
  //   iconTheme: IconThemeData(color: Colors.white),
  //   textTheme: TextTheme(
  //     headline6: TextStyle(color: Colors.white, fontSize: 18),
  //   ),
  // ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
  ),
);

// Dark theme data
ThemeData darkTheme = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.grey[900],
  // appBarTheme: AppBarTheme(
  //   color: Colors.grey[900],
  //   brightness: Brightness.dark,
  //   iconTheme: IconThemeData(color: Colors.white),
  //   textTheme: TextTheme(
  //     headline6: TextStyle(color: Colors.white, fontSize: 18),
  //   ),
  // ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
  ),
);

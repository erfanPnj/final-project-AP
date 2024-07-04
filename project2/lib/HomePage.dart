// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'package:project2/Classes.dart';
import 'package:project2/ToDo.dart';
import 'package:project2/pages.dart/Login.dart';
import 'package:ionicons/ionicons.dart';
import 'package:project2/profile.dart';

class HomePage extends StatefulWidget {
  HomePage(
      {super.key,
      required this.name,
      required this.studentNumber,
      required this.password});

  String? name;
  String? studentNumber;
  String? password;

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(debugShowCheckedModeBanner: false, home: Home());
  // }

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  String? name;
  String? studentNumber;
  String? password;

  // int _selectedIndex = 0;

  // List<Widget> pages = [Classes(), ToDo(), Classes(), ToDo(), ToDo()];

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    name = widget.name;
    studentNumber = widget.studentNumber;
    password = widget.password;
    print(name);
    print('\n');
    print(studentNumber);
    print('\n');
    print(password);
    
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // body: pages[_selectedIndex],
        // bottomNavigationBar: BottomNavigationBar(
        //   backgroundColor: Colors.blue.shade900,
        //   type: BottomNavigationBarType.fixed,
        //   items: const <BottomNavigationBarItem>[
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.home),
        //       label: 'Home',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.task),
        //       label: 'Tasks',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.class_),
        //       label: 'Classes',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.assignment),
        //       label: 'Assign',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.newspaper),
        //       label: 'News',
        //     ),
        //   ],
        //   currentIndex: _selectedIndex,
        //   selectedItemColor: Colors.white,
        //   unselectedItemColor: Colors.white70,
        //   onTap: _onItemTapped,
        // ),
        appBar: AppBar(
          backgroundColor: Colors.blue.shade900,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text("HomePage"),
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => profile(
                      name: name,
                      studentNumber: studentNumber,
                      password: password),
                ),
              );
            },
            icon: Icon(
              Ionicons.person_outline,
              color: Colors.white,
            ),
            alignment: Alignment.topRight,
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => login()));
              },
              icon: Icon(Icons.login),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

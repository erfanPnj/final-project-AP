// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'package:project2/Classes.dart';
import 'package:project2/ToDo.dart';
import 'package:project2/pages.dart/Login.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Home());
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // int _selectedIndex = 0;

  // List<Widget> pages = [Classes(), ToDo(), Classes(), ToDo(), ToDo()];

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

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
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => login()));
              },
              icon: Icon(Icons.login),
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}

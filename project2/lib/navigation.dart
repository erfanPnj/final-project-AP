import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project2/Assignments.dart';
import 'package:project2/Classes.dart';
import 'package:project2/Dart/Assignment.dart';
import 'package:project2/HomePage.dart';
import 'package:project2/News.dart';
import 'package:project2/ToDo.dart';

class Navigation extends StatefulWidget {
  Navigation(
      {super.key,
      required this.name,
      required this.studentNumber,
      required this.password});
  String? name;
  String? studentNumber;
  String? password;

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
// <<<<<<< HEAD
//   int _selectedIndex = 0;

//   List<Widget> pages = [Home(), ToDo(), Classes(), Assignments(), ToDo()];
// =======
  String? name;
  String? studentNumber;
  String? password;
  int _selectedIndex = 0;

  List<Widget> pages = [];
// >>>>>>> e829487e463c1aa1de0a57948655e477921dbdd4

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

// <<<<<<< HEAD
// =======
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
    pages = [
      HomePage(name: name, password: password, studentId: studentNumber),
      // HomePage(),
      ToDo(),
      Classes(name: name, password: password, studentNumber: studentNumber),
      Assignments(),
      News()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue.shade900,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Classes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Assign',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        onTap: _onItemTapped,
      ),
    );
  }
}

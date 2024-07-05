// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:project2/Dart/Course.dart';
import 'package:project2/Dart/Faculty.dart';
import 'package:project2/Dart/Teacher.dart';

class Classes extends StatefulWidget {
  Classes(
      {super.key,
      required this.name,
      required this.studentNumber,
      required this.password});

  String? name;
  String? studentNumber;
  String? password;

  @override
  State<Classes> createState() => _ClassesState();
}

class _ClassesState extends State<Classes> {
  String? name;
  String? studentNumber;
  String? password;
  String response = '';
  late List<String> proccessedResponse = [];
  List<Teacher> teachers = [];
  List<Course> courses = [];
  int _selectedIndex = 0;
  bool isFocused = false;
  Faculty faculty = Faculty('computer engineering', 2);

  // static final List<Widget> _widgetOptions = <Widget>[
  //   Text('Home Page'),
  //   Text('Search Page'),
  //   Text('Classes Page'),
  //   Text('Profile Page'),
  //   Text('Settings Page'),
  // ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> getCoursesForOneStudent() async {
    try {
      final socket = await Socket.connect('***REMOVED***', 8080);
      socket.write('getCoursesForOneStudent~${widget.studentNumber}\u0000');
      socket.flush();

      socket.listen((event) {
        response = String.fromCharCodes(event);
        setState(() {
          proccessedResponse = splitor(response, '^');

          if (proccessedResponse[0] == '400') {
            courses.clear(); // Clear previous courses
            for (int i = 1; i < proccessedResponse.length; i++) {
              List<String> courseTeacher = splitor(proccessedResponse[i], '|');
              List<String> course = splitor(courseTeacher[0], '~');
              List<String> teacher = splitor(courseTeacher[1], '~');

              courses.add(
                Course(
                  course[0],
                  Teacher(teacher[0], teacher[1], int.parse(teacher[2])),
                  int.parse(course[2]),
                  course[3],
                  faculty.semester!,
                  bool.parse(course[4]),
                  course[5], int.parse(course[6])
                ),
              );
            }
          }
        });
      });

      //  await socket.done;
    } catch (e) {
      print("Error: $e");
    }
  }
  
  List<String> splitor(String entry, String regex) {
    return entry.split(regex);
  }

  @override
  void initState() {
    super.initState();
    name = widget.name;
    studentNumber = widget.studentNumber;
    password = widget.password;
  }

  void _showAddItemModal() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Container(
              margin: EdgeInsets.fromLTRB(15, 8, 15, 8),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.school,
                          size: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Add new class",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Course code",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    cursorColor: Colors.blue.shade900,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.blue.shade900, width: 2.0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.blue.shade900, width: 1.0),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: "Enter the Course code"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      // read from the allCourses list and add to students course
                      Navigator.pop(context);
                    },
                    // ignore: sort_child_properties_last
                    child: Container(
                      width: 200,
                      height: 40,
                      child: Center(
                        child: Text(
                          "Add",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.blue.shade900)),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //getCoursesForOneStudent();
    return RefreshIndicator(
      onRefresh: getCoursesForOneStudent,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
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
        // );
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
              child: Row(
                children: [
                  Column(
                    children: [
                      Text(
                        "Classes",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateTime.now().toString().split(' ')[0],
                        style: TextStyle(color: Colors.grey.shade500),
                      )
                    ],
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.yellow.shade900),
                      ),
                      onPressed: _showAddItemModal,
                      child: Row(
                        children: [
                          Text(
                            "Add Class",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    color: Colors.blue.shade900,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 5, 5),
                              child: Icon(
                                Icons.school,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                            Text(
                              courses[index].courseName,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(
                                "Professor: ${courses[index].courseTeacher.name}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.white,
                          thickness: 2,
                          indent: 20,
                          endIndent: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 5, 0, 0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.format_list_numbered,
                                color: Colors.white,
                                size: 25,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Number of units: ${courses[index].countOfUnits}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 5, 0, 5),
                          child: Row(
                            children: [
                              Icon(
                                Icons.quiz,
                                color: Colors.white,
                                size: 25,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Exam date : ${courses[index].examDate}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 5, 0, 5),
                          child: Row(
                            children: [
                              Icon(
                                Icons.menu_book,
                                color: Colors.white,
                                size: 25,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Count of Assignments : ${courses[index].countOfAssignments}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

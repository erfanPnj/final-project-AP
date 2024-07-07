// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project2/Classes.dart';
import 'package:project2/Dart/Assignment.dart';
import 'package:project2/Dart/Course.dart';
import 'package:project2/Dart/Faculty.dart';
import 'package:project2/Dart/Student.dart';
import 'package:project2/Dart/Teacher.dart';
import 'package:project2/ToDo.dart';
import 'package:project2/pages.dart/Login.dart';
import 'package:project2/profile.dart';
import 'package:project2/Assignments.dart';

class HomePage extends StatefulWidget {
  HomePage(
      {super.key,
      required this.name,
      required this.studentId,
      required this.password});
  String? name;
  String? studentId;
  String? password;

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  String? _name;
  String? _studentId;
  String? _password;
  // Student? x;
  String response = '';
  String responseForNewCourse = '';
  late List<String> proccessedResponse = [];
  List<Teacher> teachers = [];
  List<Course> courses = [];
  int countOfAssignments = 0;
  double? worstScore;
  double? bestScore;
  List<MapEntry<String, String>> tasks = [];
  List<bool> expanded = [];
  Map<String, bool> isDone = {};
  List<Assignment> tamrina = [];
  List<String> bestAndWorst = [];
  Faculty faculty = Faculty('computer engineering', 2);

  Future<void> getCoursesForOneStudent() async {
    try {
      final socket = await Socket.connect('***REMOVED***', 8080);
      socket.write('getCoursesForOneStudent~${widget.studentId}\u0000');
      socket.flush();

      socket.listen((event) {
        response = String.fromCharCodes(event);
        setState(() {
          proccessedResponse = splitor(response, '^');

          if (proccessedResponse[0] == '400') {
            // courses.clear(); // Clear previous courses
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
                    course[5],
                    int.parse(course[6])),
              );
              // countOfAssignments += course[6] as int;
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
    
    tasks = ToDo.getTasks().take(2).toList();
    expanded = ToDo.getexpanded().take(2).toList();
    tamrina = Assignments.getTamrina();
    isDone = Assignments.getIsDone();
    _name = widget.name;
    _studentId = widget.studentId;
    _password = widget.password;
    print('home$_name');
    print('home$_studentId');
    print('home$_password');
    getCoursesForOneStudent();
    showBestAndWorstScore();
  }

  Future<void> showBestAndWorstScore() async {
    await Socket.connect('***REMOVED***', 8080).then((serverSocker) {
      print('---------------------------------show---------------------------');
      serverSocker.write('getBestAndWorstScore~$_studentId\u0000');
      serverSocker.flush();
      serverSocker.listen((event) {
        bestAndWorst = splitor(String.fromCharCodes(event), '|'); 
        if (bestAndWorst[0] == '400') {
          worstScore = double.parse(bestAndWorst[1]);
          bestScore = double.parse(bestAndWorst[bestAndWorst.length - 1]);
          print(bestScore);
          print(worstScore);
        }
      });
      
    });
  }

  @override
  Widget build(BuildContext context) {
    for (Course course in courses) {
      countOfAssignments += course.countOfAssignments;
    }
    showBestAndWorstScore();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
              child: Row(
                children: [
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => profile(
                            name: _name,
                            studentNumber: _studentId,
                            password: _password,
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.account_circle,
                      size: 32,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 280, 20),
              child: Text(
                "Review",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
              child: Row(
                children: [
                  Card(
                    color: Colors.white,
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 30, 8, 30),
                      child: Column(
                        children: [
                          Icon(Icons.lock_clock),
                          Text("$countOfAssignments assignments left")
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Card(
                    color: Colors.white,
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 30, 8, 30),
                      child: Column(
                        children: [
                          Icon(Icons.heart_broken_outlined),
                          Text("Worst score's $worstScore")
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 10, 0),
              child: Row(
                children: [
                  Card(
                    color: Colors.white,
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 30, 15, 30),
                      child: Column(
                        children: [
                          Icon(Icons.emoji_emotions_outlined),
                          Text("Best score's $bestScore")
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Card(
                    color: Colors.white,
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 30, 15, 30),
                      child: Column(
                        children: [
                          Icon(Icons.school),
                          Text("You've ${courses.length} classes")
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 220, 0),
              child: Text(
                "Do your tasks",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: tasks.isEmpty ? 100 : 0),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: 90,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: Colors.blue.shade900, width: 2)),
                    child: ListTile(
                      trailing: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 5, 20),
                        child: Icon(
                          expanded[index] ? Icons.check : Icons.close,
                          color: expanded[index]
                              ? Colors.green.shade500
                              : Colors.red.shade500,
                        ),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 120, 20),
                        child: Column(
                          children: [
                            Text(
                              tasks[index].key,
                              style: TextStyle(
                                color: Colors.blue.shade900,
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              tasks[index].value,
                              style: TextStyle(color: Colors.blue.shade900),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 100, 0),
              child: Text(
                "Completed assignments",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 10, 20),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.topRight,
                      children: <Widget>[
                        Card(
                          color: Colors.white,
                          elevation: 4,
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 30, 8, 30),
                              child:
                                  // Icon(Icons.lock_clock),
                                  Text("should fix Assignments")),
                        ),
                        Positioned(
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Stack(
                      alignment: Alignment.topRight,
                      children: <Widget>[
                        Card(
                          color: Colors.white,
                          elevation: 4,
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 30, 8, 30),
                              child:
                                  // Icon(Icons.lock_clock),
                                  Text("       First         ")),
                        ),
                        Positioned(
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project2/Dart/Assignment.dart';
import 'package:project2/Dart/Course.dart';
import 'package:project2/Dart/Faculty.dart';
import 'package:project2/Dart/Teacher.dart';
import 'package:project2/ToDo.dart';
import 'package:project2/profile.dart';
import 'package:project2/Assignments.dart';
import 'package:project2/theme.dart';
import 'package:project2/theme_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage(
      {super.key,
      required this.name,
      required this.studentId,
      required this.password});
  String? name;
  String? studentId;
  String? password;

  static Faculty faculty = Faculty('computer engineering', 2);
  static int? semester = faculty.semester;
  static List<Course> coursesForCountOfUnits = [];

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  String? _name;
  String? _studentId;
  String? _password;
  String response = '';
  String responseForNewCourse = '';
  late List<String> proccessedResponse = [];
  List<Teacher> teachers = [];
  List<Course> courses = [];
  int countOfAssignments = 0;
  double? worstScore;
  double? bestScore;
  List<MapEntry<String, DateTime>> tasks = [];
  List<bool> expanded = [];
  Map<String, bool> isDone = {};
  List<Assignment> assigns = [];
  List<String> bestAndWorst = [];

  Future<void> getCoursesForOneStudent() async {
    try {
      final socket = await Socket.connect('YOURIP', 8080);
      socket.write('getCoursesForOneStudent~${widget.studentId}\u0000');
      socket.flush();

      socket.listen((event) {
        response = String.fromCharCodes(event);
        setState(() {
          proccessedResponse = splitor(response, '^');

          if (proccessedResponse[0] == '400') {
            for (int i = 1; i < proccessedResponse.length; i++) {
              List<String> courseTeacher = splitor(proccessedResponse[i], '|');
              List<String> course = splitor(courseTeacher[0], '~');
              List<String> teacher = splitor(courseTeacher[1], '~');

              var faculty = HomePage.faculty;
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
              HomePage.coursesForCountOfUnits = courses;
            }
          }
        });
      });
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
    assigns = [];
    assigns = Assignments.getTamrina();
    isDone = Assignments.getIsDone();
    for (var element in isDone.values) {
      if (element == true) {
      }
    }
    _name = widget.name;
    _studentId = widget.studentId;
    _password = widget.password;
    getCoursesForOneStudent();
    showBestAndWorstScore();
  }

  Future<void> showBestAndWorstScore() async {
    await Socket.connect('YOURIP', 8080).then((serverSocker) {
      serverSocker.write('getBestAndWorstScore~$_studentId\u0000');
      serverSocker.flush();
      serverSocker.listen((event) {
        bestAndWorst = splitor(String.fromCharCodes(event), '|');
        if (bestAndWorst[0] == '400') {
          worstScore = double.parse(bestAndWorst[1]);
          bestScore = double.parse(bestAndWorst[bestAndWorst.length - 1]);
        } else if (bestAndWorst[0] == '404') {
          worstScore = 0;
          bestScore = 0;
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
    Assignments.getTamrina();
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
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
              child: Row(
                children: [
                  Card(
                    color: Provider.of<ThemeProvider>(context).themeData ==
                            darkTheme
                        ? Colors.blue.shade900
                        : Colors.white,
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
                  Spacer(),
                  Card(
                    color: Provider.of<ThemeProvider>(context).themeData ==
                            darkTheme
                        ? Colors.blue.shade900
                        : Colors.white,
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 30, 3, 30),
                      child: Column(
                        children: [
                          Icon(Icons.heart_broken_outlined),
                          Text(worstScore == null
                              ? "Worst score: 0.0"
                              : "Worst score: $worstScore")
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
              child: Row(
                children: [
                  Card(
                    color: Provider.of<ThemeProvider>(context).themeData ==
                            darkTheme
                        ? Colors.blue.shade900
                        : Colors.white,
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 30, 10, 30),
                      child: Column(
                        children: [
                          Icon(Icons.emoji_emotions_outlined),
                          Text(bestScore == null
                              ? "Best score: 0.0"
                              : "Best score: $bestScore")
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Card(
                    color: Provider.of<ThemeProvider>(context).themeData ==
                            darkTheme
                        ? Colors.blue.shade900
                        : Colors.white,
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 30, 10, 30),
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
              padding: const EdgeInsets.fromLTRB(10, 10, 20, 0),
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
                        padding: const EdgeInsets.fromLTRB(0, 5, 30, 20),
                        child: Column(
                          children: [
                            Text(
                              tasks[index].key,
                              style: TextStyle(
                                color: Provider.of<ThemeProvider>(context)
                                            .themeData ==
                                        darkTheme
                                    ? Colors.white
                                    : Colors.blue.shade900,
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              tasks[index].value.toString().split(' ')[0],
                              style: TextStyle(
                                  color: Provider.of<ThemeProvider>(context)
                                              .themeData ==
                                          darkTheme
                                      ? Colors.white
                                      : Colors.blue.shade900),
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
                "Previous assignments",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Container(
                height: 200,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: assigns.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Card(
                              color: Provider.of<ThemeProvider>(context)
                                          .themeData ==
                                      darkTheme
                                  ? Colors.blue.shade900
                                  : Colors.white,
                              elevation: 4,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(8, 30, 8, 30),
                                child:
                                    // Icon(Icons.lock_clock),
                                    Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    assigns[index].name,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            child: Icon(
                              assigns[index].status == false
                                  ? Icons.check_circle
                                  : Icons.stop_circle,
                              color: assigns[index].status == false
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

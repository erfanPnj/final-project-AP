// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project2/Classes.dart';
import 'package:project2/Dart/Assignment.dart';
import 'package:project2/Dart/Student.dart';
import 'package:project2/ToDo.dart';
import 'package:project2/pages.dart/Login.dart';
import 'package:project2/profile.dart';
import 'package:project2/Assignments.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Student x = Student("Ali", "321", "nafahmi yevaqt");
  int numOfAssignments = 0;
  double worstScore = 20;
  double bestScore = 0;
  List<MapEntry<String, String>> tasks = [];
  List<bool> expanded = [];
  Map<String, bool> isDone = {};
  List<Assignment> tamrina = [];

  @override
  void initState() {
    super.initState();
    for (var course in x.courses) {
      numOfAssignments += course.countOfAssignments;
      if (course.scores[x]! < worstScore) {
        worstScore = course.scores[x]!;
      }
      if (course.scores[x]! > bestScore) {
        bestScore = course.scores[x]!;
      }
    }
    tasks = ToDo.getTasks().take(2).toList();
    expanded = ToDo.getexpanded().take(2).toList();
    tamrina = Assignments.getTamrina();
    isDone = Assignments.getIsDone();
  }

  @override
  Widget build(BuildContext context) {
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
                            name: x.name,
                            studentNumber: x.studentId,
                            password: x.password,
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
              padding: const EdgeInsets.fromLTRB(30, 0, 10, 0),
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
                          Text("${numOfAssignments} assignments left")
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
                          Text("Worst score's ${worstScore}")
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 15, 10, 0),
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
                          Text("Best score's ${bestScore}")
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
                          Text("You've ${x.countOfCourses} classes")
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
            Padding(
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
                                Text("       First           ")),
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
          ],
        ),
      ),
    );
  }
}

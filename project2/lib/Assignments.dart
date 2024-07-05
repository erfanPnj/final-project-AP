// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project2/Dart/Assignment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Assignments extends StatefulWidget {
  const Assignments({super.key});

  @override
  State<Assignments> createState() => _AssignmentsState();
  static List<Assignment> getTamrina() {
    return tamrina;
  }

  static Map<String, bool> getIsDone() {
    return isDone;
  }
}

List<Assignment> tamrina = [];
List<Assignment> tamrinaInDay = [];
final TextEditingController _dateController = TextEditingController();
Map<String, bool> isDone = {};
bool pressed = false;

class _AssignmentsState extends State<Assignments> {
  @override
  void initState() {
    super.initState();
    Assignment assi1 = Assignment("آزمایشگاه", 5, true, "azmayeshgah");
    Assignment assi2 = Assignment("َap", 4, true, "azmayeshgah");
    Assignment assi3 = Assignment("fizik2", 6, true, "azmayeshgah");
    Assignment assi4 = Assignment("riazi2", 5, true, "azmayeshgah");
    tamrina.add(assi1);
    tamrina.add(assi2);
    tamrina.add(assi3);
    tamrina.add(assi4);
    isDone[assi1.name] = false;
    isDone[assi2.name] = false;

    isDone[assi3.name] = false;
    isDone[assi4.name] = false;

    if (_dateController.text == "") {
      setState(() {
        _dateController.text = DateTime.now().toString();
        inDay();
      });
    }
  }

  void inDay() {
    setState(() {
      tamrinaInDay.clear();
      for (var tamrin in tamrina) {
        if (tamrin.deadline ==
                int.tryParse(
                    _dateController.text.split(" ")[0].split("-")[2]) &&
            int.tryParse(_dateController.text.split(" ")[0].split("-")[1]) ==
                DateTime.now().month &&
            int.tryParse(_dateController.text.split(" ")[0].split("-")[0]) ==
                DateTime.now().year) {
          tamrinaInDay.add(tamrin);
        }
      }
    });
  }

  void _showDialog(Assignment tamrin, Map isDone) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 220,
            width: 4000,
            child: Column(
              children: [
                Row(
                  children: [
                    Text("Title: "),
                    Text(
                      tamrin.name,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    Spacer(),
                    Text("Deadline: "),
                    Text(
                      "${tamrin.deadline} more days",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text("Estimated time: "),
                    Expanded(
                      child: TextFormField(
                        cursorColor: Colors.grey.shade600,
                        style: TextStyle(color: Colors.grey.shade600),
                        decoration: InputDecoration(border: InputBorder.none),
                        initialValue: "??",
                      ),
                    ),
                    Text(
                      "day",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Explanation: ")),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  cursorColor: Colors.grey.shade900,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:
                            BorderSide(color: Colors.grey.shade600, width: 1)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:
                            BorderSide(color: Colors.grey.shade600, width: 2)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Score: (not fixed)")),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isDone[tamrin.name] = true;
                  });
                  Navigator.of(context).pop();
                },
                child: Text("Save"),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectedDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
      initialDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: const Color.fromARGB(
                  255, 142, 206, 239)!, // Header background color
              onPrimary: Colors.white, // Header text color
              surface: Colors.blue[900]!, // Background color of the calendar
              onSurface: Colors.grey[300]!, // Text color of the days
            ),
            dialogBackgroundColor:
                Colors.blue[700]!, // Background color of the dialog
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dateController.text = picked.toString().split(" ")[0];
        inDay();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.fromLTRB(15, 40, 15, 0),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  Text(
                    "Assignments",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _dateController.text.split(' ')[0],
                    style: TextStyle(color: Colors.grey.shade500),
                  )
                ],
              ),
              Spacer(),
              Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                      onPressed: (_selectedDate),
                      icon: Icon(
                        Icons.calendar_month_rounded,
                        color: Colors.blue,
                      )))
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tamrinaInDay.length,
              itemBuilder: (context, index) {
                Assignment tamrin = tamrinaInDay[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: GestureDetector(
                    onLongPress: () {
                      setState(() {
                        _showDialog(tamrin, isDone);
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      // height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.blue.shade900, width: 1)),
                      child: ListTile(
                        trailing: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isDone[tamrin.name] = !isDone[tamrin.name]!;
                              });
                            },
                            child: Icon(
                              isDone[tamrin.name]!
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              color: Colors.blue.shade500,
                            ),
                          ),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 15, 130, 15),
                          child: Row(
                            children: [
                              Text(
                                tamrinaInDay[index].name,
                                // style: TextStyle(
                                //     decoration:  TextDecoration.lineThrough),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}

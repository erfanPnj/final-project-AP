// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project2/Dart/Assignment.dart';
import 'package:intl/intl.dart';

class Assignments extends StatefulWidget {
  Assignments({super.key, required this.studentId});

  String? studentId;
  @override
  State<Assignments> createState() => _AssignmentsState();
  static List<Assignment> getTamrina() {
    return assinments;
  }

  static Map<String, bool> getIsDone() {
    return isDone;
  }
}

List<Assignment> assinments = [];
List<Assignment> assignmentsInDay = [];
final TextEditingController _dateController = TextEditingController();
Map<String, bool> isDone = {};
// bool pressed = false;

class _AssignmentsState extends State<Assignments> {
  String? _studentId;
  var _fileByte = "notUploaded yet!";
  List<String> response = [];

  @override
  void initState() {
    super.initState();
    _studentId = widget.studentId;
    requestAssignments();
    validateAssignments(assinments);
    // Assignment assi1 =
    //     Assignment("آزمایشگاه", 5, true, "azmayeshgah", "2024.1.1");
    // Assignment assi2 = Assignment("َap", 4, true, "azmayeshgah", "2024.1.1");
    // Assignment assi3 = Assignment("fizik2", 6, true, "azmayeshgah", "2024.1.1");
    // Assignment assi4 = Assignment("riazi2", 5, true, "azmayeshgah", "2024.1.1");
    // assinments.add(assi1);
    // assinments.add(assi2);
    // assinments.add(assi3);
    // assinments.add(assi4);
    // isDone[assi1.name] = false;
    // isDone[assi2.name] = false;

    // isDone[assi3.name] = false;
    // isDone[assi4.name] = false;
    print(_studentId);
    print(assinments.length);

    if (_dateController.text == "") {
      setState(() {
        _dateController.text = DateTime.now().toString();
        inDay();
      });
    }
  }

  Future<void> requestAssignments() async {
    await Socket.connect('***REMOVED***', 8080).then((serverSocket) {
      serverSocket.write('requestAssignments~$_studentId~\u0000');
      serverSocket.listen((event) {
        response = splitor(String.fromCharCodes(event), "|");
        if (response[0] == '400') {
          assinments.clear();
          for (int i = 1; i < response.length; i++) {
            List<String> eachAssignmentData = splitor(response[i], '~');
            Assignment toBeAdded = Assignment(
              eachAssignmentData[0],
              int.parse(eachAssignmentData[1]),
              bool.parse(eachAssignmentData[2]),
              eachAssignmentData[3],
              eachAssignmentData[4],
            );
            isDone[eachAssignmentData[0]] = false;
            assinments.add(toBeAdded);
          }
        } else {
          showToast(context, 'something went wrong, try again later!');
        }
      });
    });
  }

  void showToast(BuildContext context, String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue.shade900,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  List<String> splitor(String entry, String regex) {
    return entry.split(regex);
  }

  void inDay() {
    setState(
      () {
        // _dateController.text = DateTime.now().toString();
        assignmentsInDay.clear();
        for (var assignment in assinments) {
          List<int> date = [];
          for (String s in assignment.returnDefiningDate) {
            // print(s);
            date.add(int.parse(s));
          }
          for (var element in date) {
            print(element);
          }
          // print(date.length);
          // print('llllllllllllllllllllllllll');
          // print(int.tryParse(
          //             _dateController.text.split(" ")[0].split("-")[2]));
          // print('llllllllllllllllllllllllll');
          List<String> pickedDate = splitor(_dateController.text, '-');
          if (date[2] == int.parse(pickedDate[2]) &&
              int.parse(pickedDate[1]) == date[1] &&
              int.parse(pickedDate[0]) == date[0]) {
            assignmentsInDay.add(assignment);
          }
        }
        // _dateController.text = '';
      },
    );
  }

  void _showDialog(Assignment tamrin, Map isDone) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 270,
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
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text("Upload: $_fileByte"),
                    IconButton(
                        onPressed: _pickfile, icon: Icon(Icons.upload_file))
                  ],
                )
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

  void validateAssignments(List<Assignment> assinments) {
    DateTime definingDate;
    DateTime currentTime = DateTime.now();
    for (var assinment in assinments) {
      definingDate = parseDate(assinment.definingDate);
      if (assinment.deadline <
          calculateDifferenceInDays(currentTime, definingDate)) {
        assinment.status =
            false; // assignments should be disabled after deadline
      }
    }
  }

  DateTime parseDate(String dateString) {
    DateFormat dateFormat = DateFormat('yyyy.MM.dd');
    return dateFormat.parse(dateString);
  }

  int calculateDifferenceInDays(DateTime date1, DateTime date2) {
    Duration difference = date1.difference(date2);
    return difference.inDays;
  }

  @override
  Widget build(BuildContext context) {
    validateAssignments(assinments);
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
              itemCount: assignmentsInDay.length,
              itemBuilder: (context, index) {
                Assignment _assignment = assignmentsInDay[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: GestureDetector(
                    onLongPress: () {
                      _assignment.status
                          ? setState(() {
                              _showDialog(_assignment, isDone);
                            })
                          : showToast(context, 'this assignment is expired!');
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
                                isDone[_assignment.name] =
                                    !isDone[_assignment.name]!;
                              });
                            },
                            child: Icon(
                              isDone[_assignment.name]!
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
                                assignmentsInDay[index].name,
                                style: TextStyle(
                                    decoration: _assignment.status
                                        ? TextDecoration.none
                                        : TextDecoration.lineThrough),
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

  void _pickfile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        // allowedExtensions: ['jpg', 'pdf'],
        );

    if (result != null && result.files.single.path != null) {
      // File file = File(result.files.single.path);
      PlatformFile file = result.files.first;
      print(file.name);
      File _file = File(result.files.single.path!);
      setState(() {
        _fileByte = file.size.toString();
      });
    } else {
      print("No file selected");
    }
  }
}

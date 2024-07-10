// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:project2/Assignments.dart';
import 'package:project2/Dart/Assignment.dart';
import 'package:project2/flutter_local_notification.dart';
import 'package:project2/theme.dart';
import 'package:project2/theme_provider.dart';
import 'package:provider/provider.dart';

class ToDo extends StatefulWidget {
  ToDo({super.key, required this.studentId});

  String? studentId;
  @override
  State<ToDo> createState() => _ToDoState();
  static List<MapEntry<String, DateTime>> getTasks() {
    return tasks.entries.toList();
  }

  static List<bool> getexpanded() {
    return expanded;
  }
}

//keys are Task names , values are dates of them
Map<String, DateTime> tasks = new Map();
var page = 1;
DateTime now = DateTime.now();
DateTime x = DateTime(now.year, now.month, now.day);
// checks if the task is done
List<bool> expanded = [];
Map<String, DateTime> undoneTasks = {};

class _ToDoState extends State<ToDo> {
  String? _studentId;
  List<String> response = [];
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  void undoneFill() {
    setState(() {
      undoneTasks.clear();
      for (var i = 0; i < expanded.length; i++) {
        if (!expanded[i] && i < tasks.length) {
          undoneTasks[tasks.keys.toList()[i]] = tasks.values.toList()[i];
          for (var element in undoneTasks.keys) {
            print(element);
          }
        }
      }
    });
  }

  String NotificationString() {
    String body = '';
    for (var tamrin in tasks.keys) {
      body += '$tamrin, ';
    }
    return body;
  }

  @override
  void initState() {
    super.initState();
    _studentId = widget.studentId;
    requestTasks();
    LocalNotifications.showScheduleNotification(
      title: "Todays tasks",
      body: NotificationString(),
      payload: "this is payload",
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
      });
    }
  }

  void _addNewItem(String newItem, DateTime date) {
    setState(() {
      tasks[newItem] = date;
      expanded.add(false);
    });
  }

  Future<void> requestTasks() async {
    try {
      Socket serverSocket = await Socket.connect('***REMOVED***', 8080);
      serverSocket.write('requestTasks~$_studentId\u0000');
      await serverSocket.flush();

      serverSocket.listen((event) {
        response = splitor(String.fromCharCodes(event), '|');
        if (response[0] == '400') {
          for (int i = 1; i < response.length; i++) {
            List<String> task = splitor(response[i], '~');
            _addNewItem(task[0], parseDate(task[2]));
            expanded[i - 1] = bool.parse(task[3]);
          }
        } else {
          showToast(context, 'Something went wrong, please try again');
        }
      }, onError: (error) {
        showToast(context, 'Failed to retrieve tasks. Please try again.');
      }, onDone: () {
        serverSocket.destroy();
      });
    } catch (e) {
      showToast(context, 'Failed to connect to server. Please try again.');
    }
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

  DateTime parseDate(String dateString) {
    DateFormat dateFormat = DateFormat('yyyy.MM.dd');
    return dateFormat.parse(dateString);
  }

  DateTime parseDateForAdd(String dateString) {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    return dateFormat.parse(dateString);
  }

  List<String> splitor(String entry, String regex) {
    return entry.split(regex);
  }

  Future<void> changeTaskStatus(String title) async {
    await Socket.connect('***REMOVED***', 8080).then((serverSocket) {
      serverSocket.write('changeTaskStatus~$_studentId~$title\u0000');
      serverSocket.flush();
      serverSocket.listen((event) {
        String response = String.fromCharCodes(event);
        if (response == '400') {
          showToast(context, 'well done!');
        }
      });
    });
  }

  Future<void> deleteTask(String taskName) async {
    await Socket.connect('***REMOVED***', 8080).then((serverSocket) {
      serverSocket.write('deleteTask~$_studentId~$taskName\u0000');
      serverSocket.flush();
    });
  }

  Future<void> addTask(String taskName, String dateOfTask) async {
    await Socket.connect('***REMOVED***', 8080).then((serverSocket) {
      List<String> date = splitor(dateOfTask, '-');
      String convertedDate = '${date[0]}.${date[1]}.${date[2]}';
      serverSocket.write('addTask~$_studentId~$taskName~$convertedDate\u0000');
      serverSocket.flush();
      serverSocket.listen((event) {
        String response = String.fromCharCodes(event);
        if (response == '400') {
          showToast(context, 'task has been successfully added!');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 200,
            width: 1000,
            decoration: BoxDecoration(color: Colors.blue.shade900),
            child: Row(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 65, 0, 0),
                    child: Column(
                      children: [
                        Text(
                          'Tasks',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          x.toString().replaceAll("00:00:00.000", ""),
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(180, 0, 0, 0),
                  child: Icon(
                    Icons.calendar_month,
                    size: 80,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        page = 1;
                      });
                    },
                    child: Text(
                      'All tasks',
                      style: TextStyle(color: Colors.blue.shade900),
                    )),
                TextButton(
                    onPressed: () {
                      setState(() {
                        page = 2;
                        undoneFill();
                      });
                    },
                    child: Text(
                      'Undone tasks',
                      style: TextStyle(color: Colors.blue.shade900),
                    )),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: page == 1 ? tasks.length : undoneTasks.length,
              itemBuilder: (context, index) {
                var current = page == 1 ? tasks : undoneTasks;
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: GestureDetector(
                    onLongPress: () {
                      setState(() {
                        deleteTask(current.keys.toList()[index]);
                        tasks.remove(current.keys.toList()[index]);
                        expanded.removeAt(index);
                        undoneFill();
                      });
                    },
                    onTap: () {
                      changeTaskStatus(current.keys.toList()[index]);
                      setState(() {
                        expanded[tasks.keys
                                .toList()
                                .indexOf(current.keys.toList()[index])] =
                            !expanded[tasks.keys
                                .toList()
                                .indexOf(current.keys.toList()[index])];
                        undoneFill();
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.blue.shade900, width: 2)),
                      child: ListTile(
                        trailing: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 5, 20),
                          child: Icon(
                            expanded[tasks.keys
                                    .toList()
                                    .indexOf(current.keys.toList()[index])]
                                ? Icons.check
                                : Icons.close,
                            color: expanded[tasks.keys
                                    .toList()
                                    .indexOf(current.keys.toList()[index])]
                                ? Colors.green.shade500
                                : Colors.red.shade500,
                          ),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 30, 20),
                          child: Column(
                            children: [
                              Text(
                                current.keys.toList()[index],
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
                                current.values
                                    .toList()[index]
                                    .toString()
                                    .split(' ')[0],
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
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade900,
        onPressed: _showAddItemModal,
        tooltip: 'Add Item',
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddItemModal() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(0.0),
          child: DraggableScrollableSheet(
              expand: false,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  // color: Colors.white24,
                  height: 40,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                        child: TextFormField(
                          controller: _textController,
                          cursorColor: Colors.blue,
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue.shade900, width: 2)),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blue.shade900)),
                              hintText: "Enter new item",
                              hoverColor: Colors.blue.shade900,
                              fillColor:
                                  const Color.fromARGB(255, 127, 141, 153)),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                        child: TextField(
                          readOnly: true,
                          controller: _dateController,
                          onTap: _selectedDate,
                          decoration: InputDecoration(
                              labelText: 'Date',
                              filled: true,
                              fillColor: Color.fromARGB(255, 159, 159, 159),
                              prefixIcon: Icon(Icons.calendar_month),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blue.shade900))),
                        ),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                    color: Colors.blue.shade900, fontSize: 18),
                              ),
                              onPressed: () {
                                _textController.clear();
                                Navigator.of(context).pop();
                              },
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            TextButton(
                              child: Text(
                                'Add',
                                style: TextStyle(
                                    color: Colors.blue.shade900, fontSize: 18),
                              ),
                              onPressed: () {
                                if (_textController.text.isNotEmpty) {
                                  _addNewItem(
                                      _textController.text, parseDateForAdd(_dateController.text.toString().split(" ")[0]));
                                      print(_dateController.text.toString().split(" ")[0]);
                                  Navigator.of(context).pop();
                                  addTask(_textController.text, _dateController.text.toString().split(" ")[0]);
                                  _textController.clear();
                                  _dateController.clear();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      // )
                    ],
                  ),
                );
              }),
        );
      },
    );
  }
}

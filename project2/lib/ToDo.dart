// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class ToDo extends StatefulWidget {
  const ToDo({super.key});

  @override
  State<ToDo> createState() => _ToDoState();
  static List<MapEntry<String, String>> getTasks() {
    return tasks.entries.toList();
  }

  static List<bool> getexpanded() {
    return expanded;
  }
}

Map<String, String> tasks = new Map();

// var a = <String>{};
var page = 1;
DateTime now = DateTime.now();
DateTime x = DateTime(now.year, now.month, now.day);
List<bool> expanded = [];

class _ToDoState extends State<ToDo> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  // _ToDoState() {
  //   // Initialize expanded list based on the initial items in `a`
  //   for (var _ in a) {
  //     expanded.add(false);
  //   }
  // }

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

  void _addNewItem(String newItem, String date) {
    setState(() {
      tasks[newItem] = date;
      // a.add(newItem);
      expanded.add(false);
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
                      });
                    },
                    child: Text(
                      'Done tasks',
                      style: TextStyle(color: Colors.blue.shade900),
                    )),
                TextButton(
                    onPressed: () {
                      setState(() {
                        page = 3;
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
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: GestureDetector(
                    onLongPress: () {
                      setState(() {
                        tasks.remove(tasks.keys.toList()[index]);
                        // a.remove(a.toList()[index]);
                        expanded.removeAt(index);
                      });
                    },
                    onTap: () {
                      setState(() {
                        expanded[index] = !expanded[index];
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: 90,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.blue.shade900, width: 2)),
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
                                tasks.keys.toList()[index],
                                // a.toList()[index],
                                style: TextStyle(
                                  color: Colors.blue.shade900,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                tasks.values.toList()[index],
                                // a.toList()[index],
                                style: TextStyle(color: Colors.blue.shade900),
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
                                  _addNewItem(_textController.text,
                                      _dateController.text);
                                  _textController.clear();
                                  _dateController.clear();
                                  Navigator.of(context).pop();
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

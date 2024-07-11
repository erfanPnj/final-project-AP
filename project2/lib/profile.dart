// ignore_for_file: camel_case_types, prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings
import 'dart:collection';

import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project2/Dart/Course.dart';
import 'package:project2/HomePage.dart';
import 'package:project2/Signup.dart';
import 'package:project2/ToDo.dart';
import 'package:project2/changePassword.dart';
import 'package:project2/changeProfile.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project2/navigation.dart';
import 'package:project2/pages.dart/Login.dart';
import 'package:project2/theme.dart';
import 'package:project2/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class profile extends StatefulWidget {
  profile(
      {super.key,
      required this.name,
      required this.studentNumber,
      required this.password});

  String? name;
  String? studentNumber;
  String? password;

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  String? _name;
  String? _studentId;
  String? _password;

  File? _image;
  double? average;
  List<Course> coursesList = HomePage.coursesForCountOfUnits;
  int countOfUnits = 0;
  List<String> scores = [];

  @override
  void initState() {
    super.initState();
    _name = widget.name;
    _studentId = widget.studentNumber;
    _password = widget.password;
    _loadProfileImage();
    requestStudentAvg();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final savedImage = await saveImage(File(pickedFile.path), _studentId!);
      await saveImagePath(_studentId!, savedImage.path);
      setState(() {
        _image = savedImage;
      });
    }
  }

  Future<File> saveImage(File image, String studentNumber) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/$studentNumber.png';
    final savedImage = await image.copy(imagePath);
    return savedImage;
  }

  Future<void> saveImagePath(String studentNumber, String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(studentNumber, path);
  }

  Future<String?> getImagePath(String studentNumber) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(studentNumber);
  }

  Future<void> _loadProfileImage() async {
    final imagePath = await getImagePath(_studentId!);
    if (imagePath != null) {
      setState(() {
        _image = File(imagePath);
      });
    }
  }

  void showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ChangePassword(
          password: _password,
          studentId: _studentId,
          name: _name,
        );
      },
    );
  }

  void showChangeProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ChangeProfileDetails(
          id: _studentId,
          name: _name,
          password: _password,
        );
      },
    );
  }

  void calculateCountOfUnits() {
    for (var element in coursesList) {
      setState(() {
        countOfUnits += element.countOfUnits;
      });
    }
  }

  void deleteAccount() async {
    await Socket.connect('YOURIP', 8080).then((serverSocket) {
      serverSocket.write(
          'deleteAccount~${widget.name}~${widget.studentNumber}~${widget.password}\u0000');
      serverSocket.flush();
      serverSocket.listen((event) {
        String response = String.fromCharCode(event as int);
        if (true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Signup(),
            ),
          );
        }
      });
    });
  }

  Future<void> showDeleteAccDialog() async {
    Widget delete = TextButton(
      onPressed: () async {
        await Socket.connect('YOURIP', 8080).then((serverSocket) {
          serverSocket.write(
              'deleteAccount~${widget.name}~${widget.studentNumber}~${widget.password}\u0000');
          serverSocket.flush();
          serverSocket.listen(
            (event) {
              String response = String.fromCharCodes(event);
              if (response == '200') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Signup(),
                  ),
                );
                Navigator.of(context, rootNavigator: true).pop();
              }
            },
          );
        });
      },
      child: Text('DELETE'),
    );
    Widget cancel = TextButton(
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
      child: Text('cancel'),
    );
    AlertDialog alertDialog = AlertDialog(
      title: Text('ATTENTION!'),
      content: Text(
          'this action will permanently delete your account and is not reversible!'),
      actions: [
        cancel,
        delete,
      ],
    );
    showDialog(
      context: context,
      builder: (build) {
        return alertDialog;
      },
    );
  }

  Future<void> requestStudentAvg() async {
    await Socket.connect('YOURIP', 8080).then((serverSocker) {
      serverSocker.write('getBestAndWorstScore~$_studentId\u0000');
      serverSocker.flush();
      serverSocker.listen((event) {
        double temp = 0.0;
        scores = splitor(String.fromCharCodes(event), '|');
        if (scores[0] == '400') {
          for (int i = 1; i < scores.length; i++) {
            temp += double.parse(scores[i]);
          }
          setState(() {
            average = temp / (scores.length - 1);
            for (var element in coursesList) {
              countOfUnits += element.countOfUnits;
            }
          });
        }
      });
    });
  }

  List<String> splitor(String entry, String regex) {
    return entry.split(regex);
  }

  @override
  Widget build(BuildContext context) {
    int? semesterNumber = HomePage.semester;
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 320,
                width: 500,
                child: Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 25, 0, 10),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (builder) => Navigation(
                                          name: _name,
                                          studentNumber: _studentId,
                                          password: _password),
                                    ));
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_new_outlined,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 230,
                            ),
                            IconButton(
                                onPressed: () {
                                  Provider.of<ThemeProvider>(context,
                                          listen: false)
                                      .toggleTheme();
                                },
                                icon: Icon(
                                  Provider.of<ThemeProvider>(context)
                                              .themeData ==
                                          darkTheme
                                      ? Icons.sunny
                                      : Icons.mode_night,
                                  color: Colors.white,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: IconButton(
                                  onPressed: () {
                                    tasks = HashMap();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => login()));
                                  },
                                  icon: Icon(
                                    Icons.logout,
                                    size: 30,
                                    color: Colors.white,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: _pickImage,
                            child: _image == null
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSIKcTkARlljahDz7xR5gq-lwY3NSwsYMQdl_AlXfua4Yc2QcQ9QIG38gxtEiMGNAdoEck&usqp=CAU",
                                    ),
                                    radius: 80,
                                    backgroundColor: Colors.grey[200],
                                  )
                                : CircleAvatar(
                                    radius: 80,
                                    backgroundImage: FileImage(_image!),
                                  ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.all(8),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        _name!,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(color: Colors.blue.shade900),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
                      child: Row(
                        children: [
                          Text(
                            "Student number",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                          Spacer(),
                          Text(
                            _studentId!,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      indent: 15,
                      endIndent: 15,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                      child: Row(
                        children: [
                          Text(
                            "Current term",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                          Spacer(),
                          Text(
                            // current term
                            semesterNumber == 2
                                ? '1402-1403, second'
                                : '1402-1403, first',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      indent: 15,
                      endIndent: 15,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                      child: Row(
                        children: [
                          Text(
                            "Units",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                          Spacer(),
                          Text(
                            // count of units
                            countOfUnits.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      indent: 15,
                      endIndent: 15,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                      child: Row(
                        children: [
                          Text(
                            "Average score",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                          Spacer(),
                          Text(
                            //Average score
                            average == null? '0' : average.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue.shade900,
                ),
                height: 200,
                width: 300,
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(
                            width: 0,
                          ),
                          TextButton(
                            onPressed: () {
                              showChangeProfileDialog(context);
                            },
                            child: Text(
                              "Change profile",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      indent: 15,
                      endIndent: 15,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.key,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(
                            width: 0,
                          ),
                          TextButton(
                            onPressed: () {
                              showChangePasswordDialog(context);
                            },
                            child: Text(
                              "Change password",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue.shade900,
                ),
                height: 120,
                width: 300,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  height: 50,
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      showDeleteAccDialog();
                    },
                    child: Text(
                      "Delete account",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.grey.shade300),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )));
  }
}

// ignore_for_file: camel_case_types, prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project2/Signup.dart';
import 'package:project2/changePassword.dart';
import 'package:project2/changeProfile.dart';
import 'package:path_provider/path_provider.dart';
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

  // Future<void> _pickImage() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = File(pickedFile.path);
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _name = widget.name;
    _studentId = widget.studentNumber;
    _password = widget.password;
    _loadProfileImage();
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
        return ChangePassword(password: _password);
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 300,
                width: 500,
                child: Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 25, 0, 10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.home,
                              color: Colors.white,
                              size: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 290),
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Signup()));
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
                    ],
                  ),
                  decoration: BoxDecoration(color: Colors.blue.shade900),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 40, 0, 40),
                child: Row(
                  children: [
                    Text(
                      "name: ",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        (_name ?? ''),
                        style: TextStyle(
                          fontSize: 20,
                          // fontFamily: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 40),
                child: Row(
                  children: [
                    Text(
                      "Student Number: ",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        (_studentId ?? ''),
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    showChangeProfileDialog(context);
                  },
                  child: Text(
                    "Change profile",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.blue.shade900)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  height: 50,
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      showChangePasswordDialog(context);
                    },
                    child: Text(
                      "Change password",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.blue.shade900)),
                  ),
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}

// ignore_for_file: camel_case_types, prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project2/Signup.dart';
import 'package:project2/changePassword.dart';
import 'package:project2/changeProfile.dart';

class profile extends StatefulWidget {
  profile(
      {required this.name,
      required this.email,
      required this.studentNumber,
      required this.password});
  String? name;
  String? email;
  String? studentNumber;
  String? password;

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  String? _name;
  String? _email;
  String? _studentNumber;
  String? _password;

  @override
  void initState() {
    super.initState();
    _name = widget.name;
    _email = widget.email;
    _studentNumber = widget.studentNumber;
    _password = widget.password;
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
        return ChangeProfileDetails();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                          // Padding(
                          //   padding: const EdgeInsets.fromLTRB(0, 35, 310, 20),
                          Icon(
                            Icons.home,
                            color: Colors.white,
                            size: 30,
                          ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.fromLTRB(0, 35, 400, 20),
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
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSIKcTkARlljahDz7xR5gq-lwY3NSwsYMQdl_AlXfua4Yc2QcQ9QIG38gxtEiMGNAdoEck&usqp=CAU"),
                      backgroundColor: Colors.white,
                      radius: 80,
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
                    "Email: ",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      (_email ?? ''),
                      style: TextStyle(
                        fontSize: 20,
                        // fontFamily: FontWeight.bold
                      ),
                    ),
                  )
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
                      (_studentNumber ?? ''),
                      style: TextStyle(
                        fontSize: 20,
                        // fontFamily: FontWeight.bold
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
    );
  }
}

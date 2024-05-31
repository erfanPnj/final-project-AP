// ignore_for_file: camel_case_types, prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Column(
        children: [
          SizedBox(
            height: 300,
            width: 500,
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 35, 310, 200),
                    child: Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ElevatedButton(
                            onPressed: () {}, child: Text("Change profile")),
                      ),
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(color: Colors.blue.shade900),
            ),
          ),
          ListView(
            children: [
              Text(
                "name:" + (_name ?? ''),
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              Text("email:" + (_email ?? '')),
              Text("studentNumber:" + (_studentNumber ?? '')),
              Text("Password:" + (_password ?? '')),
            ],
          )
        ],
      )),
    );
  }
}

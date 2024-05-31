// ignore_for_file: prefer_const_constructors

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project2/profile.dart';

class Signup extends StatefulWidget {
  Signup({super.key});
  TextEditingController Name = TextEditingController();
  TextEditingController Email = TextEditingController();
  TextEditingController Password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController Studentnumber = TextEditingController();

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  void signup() {
    if (widget.Password.text != (widget.confirmPassword.text)) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Error",
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                "Please enter the passwords correctly!",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.blue.shade900,
              actions: [
                ElevatedButton(
                    onPressed: Navigator.of(context).pop, child: Text("Ok"))
              ],
            );
          });
    } else if (widget.Name.text.length < 8) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Error",
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                "Youre username is too short!",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.blue.shade900,
              actions: [
                ElevatedButton(
                    onPressed: Navigator.of(context).pop, child: Text("Ok"))
              ],
            );
          });
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => profile(
                  name: widget.Name.text,
                  email: widget.Email.text,
                  studentNumber: widget.Studentnumber.text,
                  password: widget.Password.text)));
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   iconTheme: IconThemeData(color: Colors.blue.shade900),
        //   backgroundColor: Colors.white,
        //   leading: IconButton(
        //       onPressed: () {
        //         Navigator.pop(context);
        //       },
        //       icon: Icon(Icons.arrow_back_ios_new_sharp)),
        // ),
        body: Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 60,
                    padding: EdgeInsets.only(left: 0, right: 10, top: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0),
                          spreadRadius: 2,
                          blurRadius: 0,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back_ios_new_sharp),
                          color: Colors.blue.shade900,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(46, 100, 30, 20),
                    child: Text(
                      "Create your account",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Align(
                  //     alignment: Alignment.centerLeft,
                  //     child: Padding(
                  //       padding: const EdgeInsets.only(left: 44),
                  //       child: Text(
                  //         "Email",
                  //         style: TextStyle(fontSize: 15),
                  //       ),
                  //     )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 20, 15),
                    child: TextField(
                      controller: widget.Name,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25)),
                          icon: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Icon(Icons.person),
                          ),
                          iconColor: Colors.blue.shade900,
                          hintText: "Name"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 20, 15),
                    child: TextField(
                      controller: widget.Email,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25)),
                          icon: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Icon(Icons.email),
                          ),
                          iconColor: Colors.blue.shade900,
                          hintText: "Email"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 20, 15),
                    child: TextField(
                      controller: widget.Studentnumber,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25)),
                          icon: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Icon(Icons.numbers_sharp),
                          ),
                          iconColor: Colors.blue.shade900,
                          hintText: "Student number"),
                    ),
                  ),
                  // Align(
                  //     alignment: Alignment.centerLeft,
                  //     child: Padding(
                  //       padding: const EdgeInsets.fromLTRB(44, 10, 0, 0),
                  //       child: Text(
                  //         "Password",
                  //         style: TextStyle(fontSize: 15),
                  //       ),
                  //     )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 20, 15),
                    child: TextField(
                      controller: widget.Password,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25)),
                          icon: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Icon(Icons.lock),
                          ),
                          iconColor: Colors.blue.shade900,
                          hintText: "Password"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: SizedBox(
                      height: 80,
                      width: 700,
                      child: TextField(
                        controller: widget.confirmPassword,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25)),
                            icon: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Icon(Icons.lock_outline),
                            ),
                            iconColor: Colors.blue.shade900,
                            hintText: "Confirm password"),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: SizedBox(
                      height: 50,
                      width: 250,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            textStyle: MaterialStateProperty.all(
                                TextStyle(color: Colors.white)),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue.shade900),
                          ),
                          onPressed: signup,
                          child: Text(
                            "Sign up",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

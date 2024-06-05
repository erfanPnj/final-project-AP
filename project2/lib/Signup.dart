// ignore_for_file: prefer_const_constructors

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project2/pages.dart/Login.dart';
import 'package:project2/profile.dart';

class Signup extends StatefulWidget {
  Signup({super.key});
  TextEditingController Name = TextEditingController();
  TextEditingController Password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController Studentnumber = TextEditingController();

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool passwordVisible = false;
  bool passwordVisible2 = false;

  @override
  void initState() {
    super.initState();
    passwordVisible2 = true;
    passwordVisible = true;
  }

  RegExp regex = RegExp(r'^\d+$');
  RegExp regex2 = RegExp(r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).+$');
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
    } else if (!regex.hasMatch(widget.Studentnumber.text)) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Error",
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                "Student number should only contains numbers!",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.blue.shade900,
              actions: [
                ElevatedButton(
                    onPressed: Navigator.of(context).pop, child: Text("Ok"))
              ],
            );
          });
    } else if (widget.Password.text.length < 8) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Error",
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                "Your password is too short!",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.blue.shade900,
              actions: [
                ElevatedButton(
                    onPressed: Navigator.of(context).pop, child: Text("Ok"))
              ],
            );
          });
    } else if (widget.Password.text.contains(widget.Name.text)) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Error",
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                "Your password should not contains your name!",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.blue.shade900,
              actions: [
                ElevatedButton(
                    onPressed: Navigator.of(context).pop, child: Text("Ok"))
              ],
            );
          });
    } else if (!regex2.hasMatch(widget.Password.text)) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Error",
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                "Your password should contain at least one capital and one small letter and one number!",
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
                  studentNumber: widget.Studentnumber.text,
                  password: widget.Password.text)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => login()));
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
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
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
                        controller: widget.Studentnumber,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue.shade900),
                                borderRadius: BorderRadius.circular(25)),
                            icon: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Icon(Icons.numbers_sharp),
                            ),
                            iconColor: Colors.blue.shade900,
                            hintText: "Student Id"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 20, 15),
                      child: TextField(
                        obscureText: passwordVisible2,
                        controller: widget.Password,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          icon: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Icon(Icons.lock),
                          ),
                          iconColor: Colors.blue.shade900,
                          hintText: "Password",
                          fillColor: Colors.white,
                          suffixIcon: IconButton(
                            icon: Icon(passwordVisible2
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(
                                () {
                                  passwordVisible2 = !passwordVisible2;
                                },
                              );
                            },
                          ),
                          alignLabelWithHint: false,
                          filled: true,
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: SizedBox(
                        height: 80,
                        width: 700,
                        child: TextField(
                          obscureText: passwordVisible,
                          controller: widget.confirmPassword,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25)),
                            hintText: "Confirm password",
                            icon: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Icon(Icons.lock_outline),
                            ),
                            iconColor: Colors.blue.shade900,
                            suffixIcon: IconButton(
                              icon: Icon(passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(
                                  () {
                                    passwordVisible = !passwordVisible;
                                  },
                                );
                              },
                            ),
                            alignLabelWithHint: false,
                            filled: true,
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
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
                              textStyle: WidgetStateProperty.all(
                                  TextStyle(color: Colors.white)),
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.blue.shade900),
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
      ),
    );
  }
}

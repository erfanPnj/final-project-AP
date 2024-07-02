// ignore_for_file: prefer_const_constructors, camel_case_types, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project2/HomePage.dart';
import 'package:project2/Signup.dart';
import 'package:project2/profile.dart';

class login extends StatefulWidget {
  login({super.key});

  TextEditingController studentIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  State<login> createState() => _LogInState();
}

class _LogInState extends State<login> {
  bool userIDChecker = true, passwordChecker = true;
  String response = '';

  @override
  void initState() {
    super.initState();
  }

  Future<String> login() async {
    await Socket.connect('***REMOVED***', 8080).then((serverSocket) {
      print('............Connected to server on port 8080...........');

      serverSocket.write(
          'logIn~${widget.studentIdController.text}~${widget.passwordController.text}\u0000');
      serverSocket.flush();
      serverSocket.listen((event) {
        response = String.fromCharCodes(event);
        List<String> proccessedResponse = splitor(response);

        if (proccessedResponse[0] == '200') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => profile(
                name: proccessedResponse[1],
                studentNumber: widget.studentIdController.text,
                password: widget.passwordController.text,
              ),
            ),
          );
        } else if (proccessedResponse[0] == '401') {
          _showErrorDialog('Incorrect password!');
        } else if (proccessedResponse[0] == '404') {
          _showErrorDialog('No student is registered with this student ID!');
        }
      });
    });
    return response;
  }

  List<String> splitor(String entry) {
    return entry.split('~');
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Error",
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue.shade900,
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Ok"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.blue.shade900),
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              icon: Icon(Icons.arrow_back_ios_new_sharp)),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(46, 0, 30, 30),
              child: Text(
                "Login to your Account",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 15),
              child: TextField(
                controller: widget.studentIdController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)),
                    icon: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Icon(Icons.numbers),
                    ),
                    iconColor: Colors.blue.shade900,
                    hintText: "Student Id"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: TextField(
                controller: widget.passwordController,
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
              padding: const EdgeInsets.only(top: 25),
              child: SizedBox(
                height: 50,
                width: 250,
                child: ElevatedButton(
                  style: ButtonStyle(
                    textStyle:
                        MaterialStateProperty.all(TextStyle(color: Colors.white)),
                    backgroundColor:
                       MaterialStateProperty.all(Colors.blue.shade900),
                  ),
                  onPressed: login,
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 80),
                  child: Text("Don't have an account?"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Signup()));
                  },
                  child: Text(
                    "SIGN UP!",
                    style: TextStyle(color: Colors.blue.shade900),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

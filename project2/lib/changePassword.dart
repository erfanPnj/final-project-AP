// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword(
      {super.key,
      required this.password,
      required this.studentId,
      required this.name});
  String? password;
  String? studentId;
  String? name;

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  RegExp regex = RegExp(r'^\d+$');
  RegExp regex2 = RegExp(r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).+$');
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void changePassword() async {
    await Socket.connect('***REMOVED***', 8080).then((serverSocket) {
      print('............Connected to server on port 8080...........');
      serverSocket.write(
          'changePass~${widget.studentId}~${_newPasswordController.text}\u0000');
      serverSocket.flush();
      serverSocket.listen((event) {
        String response = String.fromCharCodes(event);
        if (response == '200') {
          showToast(context, 'Your password has successfully changed!');
        } else {
          showToast(context, 'Failed to change password. Please try again.');
        }
      });
    });
  }

  void showToast(BuildContext context, String message) {
    Fluttertoast.showToast(
        msg: 'your password has successfully changed!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue.shade900,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(style: TextStyle(color: Colors.white), 'Change Password'),
      backgroundColor: Colors.blue.shade900,
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                cursorColor: Colors.white,
                controller: _oldPasswordController,
                obscureText: true,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    labelStyle: TextStyle(color: Colors.white),
                    labelText: 'Old Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your old password';
                  } else if (value != _oldPasswordController.text) {
                    return 'Enter your old password correctly';
                  }
                  return null;
                },
              ),
              TextFormField(
                cursorColor: Colors.white,
                controller: _newPasswordController,
                obscureText: true,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    labelStyle: TextStyle(color: Colors.white),
                    labelText: 'New Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new password';
                  } else if (!regex.hasMatch(widget.studentId!)) {
                    return ("Student number should only contain numbers!");
                  } else if (_newPasswordController.text.length < 8) {
                    return ("Your password is too short!");
                  } else if (_newPasswordController.text
                      .contains(widget.name!)) {
                    return ("Your password should not contain your name!");
                  } else if (!regex2.hasMatch(_newPasswordController.text)) {
                    return ("Your password should contain at least one capital and one small letter and one number!");
                  }
                  print(_newPasswordController.text);
                  print(widget.studentId);
                  return null;
                },
              ),
              TextFormField(
                cursorColor: Colors.white,
                controller: _confirmPasswordController,
                obscureText: true,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    labelStyle: TextStyle(color: Colors.white),
                    labelText: 'Confirm Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password';
                  } else if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(style: TextStyle(color: Colors.white), 'Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              changePassword();
              Navigator.of(context).pop();
            }
          },
          child: Text('Change Password'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

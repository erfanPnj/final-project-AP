// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project2/profile.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ChangeProfileDetails extends StatefulWidget {
  ChangeProfileDetails({
    super.key,
    required this.id,
    required this.name,
    required this.password,
  });

  String? id;
  String? name;
  String? password;

  @override
  State<ChangeProfileDetails> createState() => _ChangeProfileDetailsState();
}

class _ChangeProfileDetailsState extends State<ChangeProfileDetails> {
  String? _name;
  String? _id;
  String? _password;
  late TextEditingController _nameController;
  late TextEditingController _idController;
  final TextEditingController _detailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void ChangeProfileDetails() async {
    await Socket.connect('***REMOVED***', 8080).then((serverSocket) {
      print('............Connected to server on port 8080...........');
      serverSocket
          .write('changeProfile~${widget.id}~${_nameController.text}\u0000');
      serverSocket.flush();
      serverSocket.listen((event) {
        String response = String.fromCharCodes(event);
        if (response == '200') {
          showToast(context, 'Your name has successfully changed!');
        } else {
          showToast(context, 'Failed to change name. Please try again.');
        }
      });
    });
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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _idController = TextEditingController(text: widget.id);

    _nameFocusNode.addListener(() {
      setState(() {});
    });
    _idFocusNode.addListener(() {
      setState(() {});
    });
  }

  Color gray = Color.fromARGB(255, 180, 169, 169);
  Color white = Colors.white;
  FocusNode _nameFocusNode = FocusNode();

  FocusNode _idFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        style: TextStyle(color: Colors.white),
        'Change Profile Details',
      ),
      backgroundColor: Colors.blue.shade900,
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextField(
                focusNode: _nameFocusNode,
                style: TextStyle(
                  color: _nameFocusNode.hasFocus
                      ? Colors.white
                      : Color.fromARGB(255, 180, 169, 169),
                ),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _nameFocusNode.hasFocus
                          ? Colors.white
                          : Color.fromARGB(255, 180, 169, 169),
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                controller: _nameController,
              ),
              SizedBox(
                height: 12,
              ),
              TextField(
                focusNode: _idFocusNode,
                style: TextStyle(
                  color: _idFocusNode.hasFocus
                      ? Colors.white
                      : Color.fromARGB(255, 180, 169, 169),
                ),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _idFocusNode.hasFocus
                          ? Colors.white
                          : Color.fromARGB(255, 180, 169, 169),
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                controller: _idController,
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
              ChangeProfileDetails();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => profile(
                    name: _nameController.text,
                    studentNumber: _idController.text,
                    password: _password,
                  ),
                ),
              );
            }
          },
          child: Text('Change Detail'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _detailController.dispose();
    _nameFocusNode.dispose();
    _idFocusNode.dispose();
    super.dispose();
  }
}

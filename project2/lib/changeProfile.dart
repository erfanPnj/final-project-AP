// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:project2/profile.dart';

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
              // Handle profile detail change logic here
              // For now, just pop the dialog
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

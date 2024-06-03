
// import 'package:flutter/cupertino.dart';

// class MyWidget extends StatefulWidget {
//   const MyWidget({super.key});

//   @override
//   State<MyWidget> createState() => _MyWidgetState();
// }

// class _MyWidgetState extends State<MyWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ChangeProfileDetails extends StatefulWidget {
  const ChangeProfileDetails({super.key});

  @override
  State<ChangeProfileDetails> createState() => _ChangeProfileDetailsState();
}

class _ChangeProfileDetailsState extends State<ChangeProfileDetails> {
  final TextEditingController _detailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedDetail;

  final List<String> _details = [
    'Username',
    'Email',
    'Phone Number',
    'Address'
  ];

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
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedDetail,
                dropdownColor: Colors.blue.shade900,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  labelStyle: TextStyle(color: Colors.white),
                  labelText: 'Select Detail to Edit',
                ),
                items: _details.map((String detail) {
                  return DropdownMenuItem<String>(
                    value: detail,
                    child: Text(detail),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDetail = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a detail to edit';
                  }
                  return null;
                },
              ),
              if (_selectedDetail != null)
                TextFormField(
                  cursorColor: Colors.white,
                  controller: _detailController,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    labelStyle: TextStyle(color: Colors.white),
                    labelText: 'New ${_selectedDetail!}',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a new ${_selectedDetail!.toLowerCase()}';
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
              // Handle profile detail change logic here
              // For now, just pop the dialog
              Navigator.of(context).pop();
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
    super.dispose();
  }
}

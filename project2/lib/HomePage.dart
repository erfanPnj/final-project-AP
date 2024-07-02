// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'package:project2/pages.dart/Login.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Home());
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        
        // backgroundColor: Colors.blue,
        drawer: Drawer(
          backgroundColor: Colors.blue.shade900,
        ),
        appBar: AppBar(
          backgroundColor: Colors.blue.shade900,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text("HomePage"),
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => login()));
              },
              icon: Icon(Icons.login),
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, camel_case_types, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project2/HomePage.dart';
import 'package:project2/Signup.dart';

// class login extends StatefulWidget {
//   const login({super.key});

//   @override
//   State<login> createState() => _loginState();
// }

// class _loginState extends State<login> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         backgroundColor: Colors.blue,
//         appBar: AppBar(
//           title: Text("Login"),
//           titleTextStyle: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//           ),
//           iconTheme: IconThemeData(color: Colors.white),
//           backgroundColor: Colors.blue.shade900,
//           leading: IconButton(
//               onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => HomePage()));
//               },
//               icon: Icon(Icons.arrow_back_ios_new_sharp)),
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';

class login extends StatelessWidget {
  login({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void checkIfPossible() {
    print(emailController.text);
    print(passwordController.text);
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
                Navigator.pop(context);
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
                controller: emailController,
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
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: TextField(
                controller: passwordController,
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
                      textStyle: MaterialStateProperty.all(
                          TextStyle(color: Colors.white)),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blue.shade900),
                    ),
                    onPressed: checkIfPossible,
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    )),
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
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}

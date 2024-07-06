// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:project2/Search.dart';
import 'package:simple_url_preview_v2/simple_url_preview.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _NewsState();
}

final List<String> Events = ["Even1", "Event2", "Event3"];
final List<String> NewsList = [];
final List<String> Reminders = ["Reminder1", "Reminder2", "Reminder3"];
final List<String> Birthdays = ["Birthday1", "Birthday2"];
final List<String> inPage = [];
int page = 1;

class _NewsState extends State<News> {
  final List<String> searchTerms = [
    'News1',
    'News2',
    'News3',
    'President blah blah blah',
    'Shahid beheshti university blah blah ',
    'Fig',
    'Grape',
    'Honeydew',
  ];
  @override
  void initState() {
    super.initState();
    NewsList.add("News1");
    NewsList.add("News2");
    NewsList.add("News3");
    NewsList.add("News4");
    inPage.addAll(NewsList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 40, 15, 10),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      "News",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      DateTime.now().toString().split(' ')[0],
                      style: TextStyle(color: Colors.grey.shade500),
                    )
                  ],
                ),
                Spacer(),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.blue.shade900)),
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: Search(searchTerms),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        Text(
                          "Search",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          side: MaterialStatePropertyAll(
                              BorderSide(color: Colors.blue.shade900)),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.white),
                          overlayColor:
                              MaterialStatePropertyAll(Colors.blue.shade100)),
                      onPressed: () {
                        setState(() {
                          inPage.clear();
                          inPage.addAll(NewsList);
                        });
                      },
                      child: Text(
                        "News",
                        style: TextStyle(color: Colors.blue.shade900),
                      )),
                  SizedBox(
                    width: 13,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          side: MaterialStatePropertyAll(
                              BorderSide(color: Colors.blue.shade900)),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.white),
                          overlayColor:
                              MaterialStatePropertyAll(Colors.blue.shade100)),
                      onPressed: () {
                        setState(() {
                          inPage.clear();
                          inPage.addAll(Events);
                        });
                      },
                      child: Text(
                        "Events",
                        style: TextStyle(color: Colors.blue.shade900),
                      )),
                  SizedBox(
                    width: 13,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          side: MaterialStatePropertyAll(
                              BorderSide(color: Colors.blue.shade900)),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.white),
                          overlayColor:
                              MaterialStatePropertyAll(Colors.blue.shade100)),
                      onPressed: () {
                        setState(() {
                          inPage.clear();
                          inPage.addAll(Reminders);
                        });
                      },
                      child: Text(
                        "Reminders",
                        style: TextStyle(color: Colors.blue.shade900),
                      )),
                  SizedBox(
                    width: 13,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          side: MaterialStatePropertyAll(
                              BorderSide(color: Colors.blue.shade900)),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.white),
                          overlayColor:
                              MaterialStatePropertyAll(Colors.blue.shade100)),
                      onPressed: () {
                        setState(() {
                          inPage.clear();
                          inPage.addAll(Birthdays);
                        });
                      },
                      child: Text(
                        "Birthdays",
                        style: TextStyle(color: Colors.blue.shade900),
                      )),
                ],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 2,
                      color: Colors.grey,
                      indent: 15,
                      endIndent: 15,
                    ),
                  ),
                  Text(
                    "Today (${DateTime.now().month})",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 2,
                      color: Colors.grey,
                      indent: 15,
                      endIndent: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: inPage.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: Card(
                      child: Text(inPage[index]),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}

import 'package:week7_networking_discussion/models/todo_model.dart';
import 'package:week7_networking_discussion/models/user_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:week7_networking_discussion/screens/todo_page.dart';

class FriendsProfile extends StatelessWidget {
  String name = '';
  String location = '';
  String bio = '';
  String birthday = '';
  String email = '';
  FriendsProfile(
      {super.key,
      required this.name,
      required this.location,
      required this.bio,
      required this.birthday,
      required this.email});

  @override
  Widget build(BuildContext context) {
    //final args = ModalRoute.of(context)!.settings.arguments as UserModel;

    Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Hello, this is ${name}!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                /*Text(
                  'UPLB BSCS student',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),*/
              ],
            ),
          ),
          /*3*/
        ],
      ),
    );

    // Text section
    Widget textSection = Padding(
      padding: EdgeInsets.all(25),
      child: Text(
        'Name: ${name}'
        '\n\nBirthday: ${birthday} '
        '\n\nLocation: ${location}'
        '\n\nBio: ${bio}',
        softWrap: true,
      ),
    );

    Widget idSection = UnconstrainedBox(
      child: Container(
        height: 35,
        width: 250,
        decoration: BoxDecoration(
          color: Color(0xFFFFC107),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(child: Text(email)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(40),
            child: CircleAvatar(
              minRadius: 50,
              backgroundColor: Color(0xffE6E6E6),
              child: Icon(
                Icons.person,
                size: 70,
              ),
            ),
          ),
          idSection,
          titleSection,
          textSection,
        ],
      ),
    );
  }

  Widget buildInfo(String fieldName, String info) {
    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.lightBlue),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text("h"),
      ),
    );
  }
}

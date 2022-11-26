import 'package:week7_networking_discussion/models/user_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  Profile({super.key});

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
                  child: const Text(
                    'Hello, this is Roxanne Ysabel P. Resuello!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'UPLB BSCS student',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          /*3*/
        ],
      ),
    );

    // Text section
    Widget textSection = const Padding(
      padding: EdgeInsets.all(25),
      child: Text(
        'Name: Roxanne Ysabel Punzalan Resuello'
        '\n\nBirthday: June 21 2002 '
        '\n\nLocation: Balayan, Batangas '
        '\n\nBio:  I am very close with my family. I am the 2nd-born and the only girl among the four children.'
        ' As a family, we love travelling, eating, and watching movies.',
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
        child: Center(child: Text("Hi")),
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
          const Text("        Hobbies:"),
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

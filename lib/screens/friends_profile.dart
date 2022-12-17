/*
  Created by: Roxanne Ysabel Resuello
  Date: 21 November 2022
  Description: A shared todo flutter app that uses firebase with the following features:
                1. Add, delete, and edit a todo
                2. Add and delete a friend
                3. Accept and decline a friend request
                4. Sign in, Login, and Logout an account
                5. View profile
                6. View friend's profile
*/
import 'package:flutter/material.dart';

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
    // email section
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
          SizedBox(
            height: 50,
          ),
          buildInfo(Icons.person, 'Name:     ', name),
          buildInfo(Icons.celebration, 'Birthday:     ', birthday),
          buildInfo(Icons.location_pin, 'Location:     ', location),
          buildInfo(Icons.article, 'Bio:     ', bio),
        ],
      ),
    );
  }

  // Widget for showing information
  Widget buildInfo(IconData icon, String field, String info) {
    return Container(
      height: 55,
      margin: EdgeInsets.symmetric(
        horizontal: 40,
      ).copyWith(
        bottom: 20,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xFF373737),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            size: 25,
          ),
          SizedBox(width: 15),
          Text(field),
          Text(info),
        ],
      ),
    );
  }
}

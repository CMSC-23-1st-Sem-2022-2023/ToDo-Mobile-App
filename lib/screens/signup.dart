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
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/api/firebase_auth_api.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:intl/intl.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // Variable initialization
  DateTime date = DateTime.now();
  String bday = '';
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    // Name text form field
    final name = TextFormField(
      key: const Key('fName'),
      controller: nameController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter name';
        }
        return null;
      },
      decoration: const InputDecoration(
        hintText: "Name",
      ),
    );

    // Birthday text form field
    final birthday = Padding(
      key: const Key('bday'),
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () async {
              DateTime? newDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100));

              if (newDate == null) return;
              bday =
                  "${newDate.year.toString()}/${newDate.month.toString()}/${newDate.day.toString()}";
              setState(() => date = newDate);
            },
          ),
          Text(
            '  Birthday: ${date.year}/${date.month}/${date.day}',
            key: const Key('birthdayField'),
          )
        ],
      ),
    );

    // Location text form field
    final location = TextFormField(
      key: const Key('locationField'),
      controller: locationController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter location';
        }
        return null;
      },
      decoration: const InputDecoration(
        hintText: "Location",
      ),
    );

    // Bio text form field
    final bio = TextFormField(
      key: const Key('bioField'),
      controller: bioController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter bio';
        }
        return null;
      },
      decoration: const InputDecoration(
        hintText: "Bio",
      ),
    );

    // Email text form field
    final email = TextFormField(
      key: const Key('sEmail'),
      controller: emailController,
      validator: (value) {
        String pattern =
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
            r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
            r"{0,253}[a-zA-Z0-9])?)*$";
        RegExp regex = RegExp(pattern);
        if (value == null || value.isEmpty || !regex.hasMatch(value)) {
          return 'Enter valid email address';
        }
        return null;
      },
      decoration: const InputDecoration(
        hintText: "Email",
      ),
    );

    // Password text form field
    final password = TextFormField(
      key: const Key('passwordField'),
      controller: passwordController,
      validator: (value) {
        if (value == null || value.isEmpty || value.length < 6) {
          return 'Password must be atleast 6';
        }
        return null;
      },
      obscureText: true,
      decoration: const InputDecoration(
        hintText: 'Password',
      ),
    );

    // Signup button
    final signupButton = Padding(
      key: const Key('signUp'),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Color(0xFFFFC107)),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            context.read<AuthProvider>().signUp(
                nameController.text,
                bday,
                bioController.text,
                locationController.text,
                emailController.text,
                passwordController.text);
            if (FirebaseAuthAPI.alreadeyExist) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('The account already exists for that email.')));
              FirebaseAuthAPI.alreadeyExist = false;
            }
            Navigator.pop(context);
          }
        },
        child: const Text('Sign up', style: TextStyle(color: Colors.white)),
      ),
    );

    // Back button
    final backButton = Padding(
      key: const Key('back'),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Color(0xFFFFC107)),
        onPressed: () async {
          Navigator.pop(context);
        },
        child: const Text('Back', style: TextStyle(color: Colors.white)),
      ),
    );

    bday =
        "${date.year.toString()}/${date.month.toString()}/${date.day.toString()}";

    return Scaffold(
      //backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 40.0, right: 40.0),
            children: <Widget>[
              const Text(
                "Sign Up",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
              birthday,
              name,
              bio,
              location,
              email,
              password,
              signupButton,
              backButton
            ],
          ),
        ),
      ),
    );
  }
}

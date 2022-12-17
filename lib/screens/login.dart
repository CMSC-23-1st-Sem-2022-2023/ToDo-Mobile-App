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
import 'package:week7_networking_discussion/screens/signup.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    // Variable initialization
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    FirebaseAuthAPI.wrongEmail = false;
    FirebaseAuthAPI.wrongPass = false;

    // Email text form field
    final email = TextFormField(
      key: const Key('emailField'),
      controller: emailController,
      validator: (value) {
        String pattern =
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
            r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
            r"{0,253}[a-zA-Z0-9])?)*$";
        RegExp regex = RegExp(pattern);
        if (value == null ||
            value.isEmpty ||
            FirebaseAuthAPI.wrongEmail == true ||
            !regex.hasMatch(value)) {
          return 'Enter valid email';
        }
        return null;
      },
      decoration: const InputDecoration(
        hintText: "Email",
      ),
    );

    // Password text form field
    final password = TextFormField(
      key: const Key('pwField'),
      validator: (value) {
        if (value == null ||
            value.isEmpty ||
            value.length < 6 ||
            FirebaseAuthAPI.wrongPass == true) {
          return 'Password incorrect';
        }
        return null;
      },
      controller: passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: 'Password',
      ),
    );

    // Login button
    final loginButton = Padding(
      key: const Key('loginButton'),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Color(0xFFFFC107)),
        onPressed: () {
          context
              .read<AuthProvider>()
              .signIn(emailController.text, passwordController.text);
          if (_formKey.currentState!.validate()) {}
          FirebaseAuthAPI.wrongPass = false;
          FirebaseAuthAPI.wrongEmail = false;
        },
        child: const Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    // Signup button
    final signUpButton = Padding(
      key: const Key('signUpButton'),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Color(0xFFFFC107)),
        onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SignupPage(),
            ),
          );
        },
        child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      //backgroundColor: Colors.white,
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 40.0, right: 40.0),
            children: <Widget>[
              const Text(
                "Login",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
              email,
              password,
              loginButton,
              signUpButton,
            ],
          ),
        ),
      ),
    );
  }
}

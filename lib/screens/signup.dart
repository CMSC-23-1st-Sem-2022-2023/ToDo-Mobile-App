import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/api/firebase_auth_api.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    //bool validateFirst = firstNameController.text.isEmpty ? true : false;
    //bool validateFirst2 = false;

    /*bool validate(String input) {
      if (input != null || input.isNotEmpty) {
        return true;
      }
      return false;
    }*/

    /* String validateFirst(bool validateLast) {
      if (validateLast == true) {
        return "Enter text";
      }
      return '';
    } */

    final firstName = TextFormField(
      key: const Key('fName'),
      controller: firstNameController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter first name';
        }
        return null;
      },
      decoration: const InputDecoration(
        hintText: "First Name",
      ),
    );

    final lastName = TextFormField(
      key: const Key('lName'),
      controller: lastNameController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter last name';
        }
        return null;
      },
      decoration: const InputDecoration(
        hintText: "Last Name",
      ),
    );

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

    final password = TextFormField(
      key: const Key('sPass'),
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

    final signupButton = Padding(
      key: const Key('signUp'),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            context.read<AuthProvider>().signUp(
                emailController.text,
                passwordController.text,
                firstNameController.text,
                lastNameController.text);
            if (FirebaseAuthAPI.alreadeyExist) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('The account already exists for that email.')));
              FirebaseAuthAPI.alreadeyExist = false;
            }
            Navigator.pop(context);
          }

          //call the auth provider here
          /* context.read<AuthProvider>().signUp(
              emailController.text,
              passwordController.text,
              firstNameController.text,
               lastNameController.text);
          //Navigator.pop(context);
          */
        },
        child: const Text('Sign up', style: TextStyle(color: Colors.white)),
      ),
    );

    final backButton = Padding(
      key: const Key('back'),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          Navigator.pop(context);
        },
        child: const Text('Back', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
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
              firstName,
              lastName,
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

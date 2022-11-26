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
  DateTime date = DateTime.now();
  String bday = '';
  @override
  Widget build(BuildContext context) {
    TextEditingController passwordController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    TextEditingController bioController = TextEditingController();
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

    /* Future<void> _selectDate(BuildContext context) async {
      final now = DateTime.now();
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: date ?? now,
          firstDate: DateTime(1951),
          lastDate: DateTime(2023));
      if (picked != null && picked != date) {
        print('hello $picked');
        date = picked;
      }
    } */
/* 
    Widget birthday1(BuildContext context) {
      return TextFormField(
        validator: (value) {
          if (value!.isEmpty || value == null) {
            return 'Birthday is required.';
          }
          return null;
        },
        controller: birthdayController, //editing controller of this TextField
        decoration: const InputDecoration(
            icon: Icon(Icons.calendar_today), //icon of text field
            labelText: "Birthday" //label text of field
            ),
        readOnly: true, //set it true, so that user will not able to edit text
        onTap: () async {
          FocusScope.of(context).requestFocus(new FocusNode());
          // Show Date Picker Here
          await _selectDate(context);

          setState(() {
            print(date);
            birthdayController.text = DateFormat('yyyy/MM/dd').format(date!);
          });
        },
      );
    } */

    final birthday = Padding(
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

    final location = TextFormField(
      key: const Key('locationField'),
      controller: locationController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter location name';
        }
        return null;
      },
      decoration: const InputDecoration(
        hintText: "Location",
      ),
    );

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

    final signupButton = Padding(
      key: const Key('signUp'),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            context.read<AuthProvider>().signUp(
                nameController.text,
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
              name,
              birthday,
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

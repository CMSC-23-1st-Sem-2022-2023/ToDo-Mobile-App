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
import 'package:week7_networking_discussion/providers/todo_provider.dart';
import 'package:week7_networking_discussion/providers/user_provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/screens/friends_page.dart';
import 'package:week7_networking_discussion/screens/todo_page.dart';
import 'package:week7_networking_discussion/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:week7_networking_discussion/screens/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Comment for testing
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => TodoListProvider())),
        ChangeNotifierProvider(create: ((context) => AuthProvider())),
        ChangeNotifierProvider(create: ((context) => UserListProvider())),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SimpleTodo',
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(),
        '/friends': (context) => const FriendsPage(),
        '/profile': (context) => Profile(),
        '/todos': (context) => TodoPage(),
      },
      theme: ThemeData(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        primaryColor: Color(0xFF212121),
        canvasColor: Color(0xFF212121),
        brightness: Brightness.dark,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.watch<AuthProvider>().isAuthenticated) {
      return TodoPage();
    } else {
      return LoginPage();
    }
  }
}

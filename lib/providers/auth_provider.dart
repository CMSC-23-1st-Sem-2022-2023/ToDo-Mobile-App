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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:week7_networking_discussion/api/firebase_auth_api.dart';
import 'package:week7_networking_discussion/api/firebase_user_api.dart';
import 'package:week7_networking_discussion/models/todo_model.dart';
import 'package:week7_networking_discussion/screens/friends_page.dart';
import 'package:week7_networking_discussion/screens/todo_page.dart';

class AuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  static User? userObj;

  AuthProvider() {
    authService = FirebaseAuthAPI();
    authService.getUser().listen((User? newUser) {
      userObj = newUser;
      print('AuthProvider - FirebaseAuth - onAuthStateChanged - $newUser');
      //FirebaseUserAPI().setCurrentUser(userObj!.email!);
      notifyListeners();
    }, onError: (e) {
      // provide a more useful error
      print('AuthProvider - FirebaseAuth - onAuthStateChanged - $e');
    });
  }

  User? get user => userObj;

  bool get isAuthenticated {
    return user != null;
  }

  // Function for signing in
  void signIn(String email, String password) {
    authService.signIn(email, password);
  }

  // Sign out function
  void signOut() {
    TodoPage.isStart = false;
    TodoPage.todos = [];
    TodoPage.users = [];
    TodoPage.user = null;
    FriendsPage.friends = [];
    FriendsPage.requests = [];
    FriendsPage.userLength = 0;
    authService.signOut();
  }

  // Sign up function
  void signUp(String name, String birthday, String bio, String location,
      String email, String password) {
    authService.signUp(name, birthday, bio, location, email, password);
  }
}

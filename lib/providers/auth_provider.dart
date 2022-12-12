import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:week7_networking_discussion/api/firebase_auth_api.dart';
import 'package:week7_networking_discussion/api/firebase_user_api.dart';
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

  void signIn(String email, String password) {
    authService.signIn(email, password);
  }

  void signOut() {
    TodoPage.todos = [];
    TodoPage.users = [];
    FriendsPage.friends = [];
    FriendsPage.requests = [];
    FriendsPage.userLength = 0;
    authService.signOut();
  }

  void signUp(String name, String birthday, String bio, String location,
      String email, String password) {
    authService.signUp(name, birthday, bio, location, email, password);
  }
}

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
import 'package:week7_networking_discussion/api/firebase_user_api.dart';
import 'package:week7_networking_discussion/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week7_networking_discussion/screens/todo_page.dart';

class UserListProvider with ChangeNotifier {
  late FirebaseUserAPI userAPI;
  late Future<List<User>> _userList;

  Future<List<User>> get user => _userList;

  late FirebaseUserAPI firebaseService;
  late Stream<QuerySnapshot> _usersStream;
  User? _selectedUser;
  User? _otherUser;

  UserListProvider() {
    firebaseService = FirebaseUserAPI();
    fetchUsers();
  }

  // getter
  Stream<QuerySnapshot> get users => _usersStream;
  User get selected => _selectedUser!;
  User get otherUser => _otherUser!;

  // Function for setting the curent user
  setUser(User user) {
    _selectedUser = user;
  }

  // Function for setting the other user
  changeOtherUser(User user) {
    _otherUser = user;
  }

  void getUsers() {
    firebaseService.getUsers();
  }

  void fetchUsers() {
    _usersStream = firebaseService.getAllUsers();
    notifyListeners();
  }

  // Function for deleting a friend
  void deleteFriend(List<dynamic> friends, List<dynamic> otherFriends) async {
    String message =
        await firebaseService.deleteFriend(_selectedUser!.id, friends);
    message = await firebaseService.deleteFriend(_otherUser!.id, otherFriends);
    print(message);
    notifyListeners();
  }

  // Function for deleting a friend request
  void deleteRequest(List<dynamic> receivedfr, List<dynamic> sentfr) async {
    String message =
        await firebaseService.deleteRequest(_selectedUser!.id, receivedfr);
    message = await firebaseService.deleteSent(_otherUser!.id, sentfr);
    print(message);
    notifyListeners();
  }

  // Function for accepting a friend request
  void acceptRequest(List<dynamic> friends, List<dynamic> otherfriends) async {
    String message =
        await firebaseService.acceptRequest(_selectedUser!.id, friends);
    message = await firebaseService.acceptRequest(_otherUser!.id, otherfriends);
    print(message);
    notifyListeners();
  }

  // Function for adding a todo
  void addTodo(List<dynamic> todos) async {
    String message = await firebaseService.addTodo(TodoPage.user!.id, todos);
    print(message);
    notifyListeners();
  }

  // Function for deleting a todo
  void deleteTodo(List<dynamic> todos) async {
    String message = await firebaseService.deleteTodo(TodoPage.user!.id, todos);
    print(message);
    notifyListeners();
  }

  // Function for sending a friend request
  void sendRequest(List<dynamic> newSent, List<dynamic> newReceived) async {
    String message =
        await firebaseService.sendRequest(_selectedUser!.id, newSent);
    message = await firebaseService.receiveRequest(_otherUser!.id, newReceived);
    print(message);
    notifyListeners();
  }
}

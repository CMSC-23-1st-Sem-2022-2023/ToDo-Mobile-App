/*
  Created by: Roxanne Ysabel Resuello
  Date: 11 November 2022
  Description: Description: A mobile application that allows you to do the following:
  1. Add a friend
  2. Delete a friend
  3. Accept a friend request
  4. Decline a friend request
  5. Search a friend
  6. Send a friend request
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

  /* getUser() {
    _selectedUser = null;
    final docRef = firebaseService.docRef;
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        _selectedUser = User.fromJson(data);
      },
      onError: (e) => print("Error getting document: $e"),
    );
    return _selectedUser;
    //_selectedUser = User.fromJson(data);
  } */

  setUser(User user) {
    _selectedUser = user;
  }

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

  void deleteFriend(List<dynamic> friends, List<dynamic> otherFriends) async {
    String message =
        await firebaseService.deleteFriend(_selectedUser!.id, friends);
    message = await firebaseService.deleteFriend(_otherUser!.id, otherFriends);
    print(message);
    notifyListeners();
  }

  void deleteRequest(List<dynamic> receivedfr, List<dynamic> sentfr) async {
    String message =
        await firebaseService.deleteRequest(_selectedUser!.id, receivedfr);
    message = await firebaseService.deleteSent(_otherUser!.id, sentfr);
    print(message);
    notifyListeners();
  }

  void acceptRequest(List<dynamic> friends, List<dynamic> otherfriends) async {
    String message =
        await firebaseService.acceptRequest(_selectedUser!.id, friends);
    message = await firebaseService.acceptRequest(_otherUser!.id, otherfriends);
    print(message);
    notifyListeners();
  }

  void addTodo(List<dynamic> todos) async {
    String message = await firebaseService.addTodo(TodoPage.user!.id, todos);
    print(message);
    notifyListeners();
  }

  void deleteTodo(List<dynamic> todos) async {
    String message = await firebaseService.deleteTodo(TodoPage.user!.id, todos);
    print(message);
    notifyListeners();
  }

  void sendRequest(List<dynamic> newSent, List<dynamic> newReceived) async {
    String message =
        await firebaseService.sendRequest(_selectedUser!.id, newSent);
    message = await firebaseService.receiveRequest(_otherUser!.id, newReceived);
    print(message);
    notifyListeners();
  }

  Future<int> getLength() async {
    int length = await firebaseService.getLength();
    return length;
  }

  /*
  void addTodo(User item) async {
    String message = await firebaseService.addTodo(item.toJson(item));
    print(message);
    notifyListeners();
  }

  void editTodo(String newString) async {
    String message =
        await firebaseService.editTodo(_selectedTodo!.id, newString);
    print(message);
    notifyListeners();
  }

  void addFriend(String newString) async {
    String message =
        await firebaseService.addFriend(_selectedUser!.id, newString);
    print("Added");
    notifyListeners();
  }

  

  void sendRequest(String newString) async {
    String message =
        await firebaseService.editTodo(_selectedTodo!.id, newString);
    print(message);
    notifyListeners();
  }


  void deleteTodo() async {
    String message = await firebaseService.deleteTodo(_selectedTodo!.id);
    print(message);
    notifyListeners();
  }

  void toggleStatus(bool status) async {
    String message =
        await firebaseService.toggleStatus(_selectedTodo!.id, status);
    print(message);
    notifyListeners();
  }
*/
}

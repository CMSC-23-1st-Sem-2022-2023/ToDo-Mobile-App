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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week7_networking_discussion/models/todo_model.dart';
import 'package:week7_networking_discussion/screens/friends_page.dart';
import 'package:week7_networking_discussion/models/user_model.dart';
import 'package:week7_networking_discussion/screens/todo_page.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';

class FirebaseUserAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final users = FirebaseFirestore.instance.collection('users');

  Stream<QuerySnapshot> getAllUsers() {
    return db.collection("users").snapshots();
  }

  // Function for getting all users and saving it in an array in todo page
  Future<void> getUsers() async {
    TodoPage.isStart = true;
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await users.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    //print(allData);

    // For each user, add it to the array
    for (int i = 0; i < allData.length; i++) {
      User newUser = User.fromJson(allData[i] as Map<String, dynamic>);
      TodoPage.users.add(newUser);
      //print(newUser.email);
    }

    // Set the current logged in user
    for (int i = 0; i < TodoPage.users.length; i++) {
      //print(TodoPage.users[i].email);
      if (TodoPage.users[i].email == AuthProvider.userObj!.email) {
        TodoPage.user = TodoPage.users[i];
        //print("here");
        //print(TodoPage.user!.name);
      }
    }

    // Get friends of the user
    for (int i = 0; i < TodoPage.users.length; i++) {
      User checkUser = TodoPage.users[i];

      if (TodoPage.user!.friends.contains(checkUser.id) &&
          !FriendsPage.friends.contains(checkUser)) {
        FriendsPage.friends.add(checkUser);
      }
    }

    //Get friend request
    for (int i = 0; i < FriendsPage.userLength; i++) {
      User checkUser = TodoPage.users[i];
      if (TodoPage.user!.receivedFriendRequests.contains(checkUser.id) &&
          !FriendsPage.requests.contains(checkUser)) {
        FriendsPage.requests.add(checkUser);
      }
    }
    //print('friends ${FriendsPage.friends.length}');
  }

  // Function for deleting a friend
  Future<String> deleteFriend(String? id, List<dynamic> friends) async {
    try {
      final docRef = db.collection('users').doc(id);
      await docRef.update({'friends': friends});

      return "Successfully deleted a friend!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  //Function for adding a todo, updates the list of todo in firestore
  Future<String> addTodo(String? id, List<dynamic> todos) async {
    try {
      final docRef = db.collection('users').doc(id);
      await docRef.update({'todos': todos});

      return "Successfully added a todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  //Function for adding a todo, updates the list of todo in firestore
  Future<String> deleteTodo(String? id, List<dynamic> todos) async {
    try {
      final docRef = db.collection('users').doc(id);
      await docRef.update({'todos': todos});

      return "Successfully deleted a todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  //Function for accepting a request, updates the list of todo in firestore
  Future<String> acceptRequest(String? id, List<dynamic> friends) async {
    try {
      final docRef = db.collection('users').doc(id);
      await docRef.update({'friends': friends});

      return "Successfully accepted a friend!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  //Function for sending a request, updates the list of sentFriendRequest in firestore
  Future<String> sendRequest(String? id, List<dynamic> sent) async {
    try {
      final docRef = db.collection('users').doc(id);
      await docRef.update({'sentFriendRequests': sent});

      return "Successfully sent a friend request!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  //Function for receiving a request, updates the list of receivedFriendRequest in firestore
  Future<String> receiveRequest(String? id, List<dynamic> received) async {
    try {
      final docRef = db.collection('users').doc(id);
      await docRef.update({'receivedFriendRequests': received});

      return "Successfully received a friend!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  //Function for deleting a request, updates the list of receivedFriendRequest in firestore
  Future<String> deleteRequest(String? id, List<dynamic> received) async {
    try {
      final docRef = db.collection('users').doc(id);
      await docRef.update({'receivedFriendRequests': received});

      return "Successfully updated received request!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  //Function for deleting a sent request, updates the list of sentFriendRequest in firestore
  Future<String> deleteSent(String? id, List<dynamic> sent) async {
    try {
      final docRef = db.collection('users').doc(id);
      await docRef.update({'sentFriendRequests': sent});

      return "Successfully updated sent request!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
}

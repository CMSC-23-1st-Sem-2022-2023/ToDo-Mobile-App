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

import 'dart:convert';

class User {
  final String id;
  String email;
  String name;
  String location;
  String birthday;
  String bio;
  List<dynamic> todos;
  List<dynamic> friends;
  List<dynamic> receivedFriendRequests;
  List<dynamic> sentFriendRequests;

  User(
      {required this.id,
      required this.email,
      required this.name,
      required this.location,
      required this.birthday,
      required this.bio,
      required this.todos,
      required this.friends,
      required this.receivedFriendRequests,
      required this.sentFriendRequests});

  // Factory constructor to instantiate object from json format
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      location: json['location'],
      birthday: json['birthday'],
      bio: json['bio'],
      todos: json['todos'],
      friends: json['friends'],
      receivedFriendRequests: json['receivedFriendRequests'],
      sentFriendRequests: json['sentFriendRequests'],
    );
  }

  static List<User> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<User>((dynamic d) => User.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(User user) {
    return {
      'id': user.id,
      'email': user.email,
      'name': user.name,
      'location': user.location,
      'birthday': user.birthday,
      'bio': user.bio,
      'todos': user.todos,
      'friends': user.friends,
      'receivedFriendRequests': user.receivedFriendRequests,
      'sentFriendRequests': user.sentFriendRequests,
    };
  }
}

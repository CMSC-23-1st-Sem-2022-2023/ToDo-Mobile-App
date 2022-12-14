/*
  Created by: Claizel Coubeili Cepe
  Date: 27 October 2022
  Description: Sample todo app with networking
*/

import 'dart:convert';

class Todo {
  String userId;
  String? id;
  String title;
  String deadline;
  String description;
  String edit;
  bool notification;
  bool completed;

  Todo({
    required this.userId,
    this.id,
    required this.deadline,
    required this.description,
    required this.edit,
    required this.notification,
    required this.title,
    required this.completed,
  });

  // Factory constructor to instantiate object from json format
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      userId: json['userId'],
      id: json['id'],
      deadline: json['deadline'],
      description: json['description'],
      edit: json['edit'],
      notification: json['notification'],
      title: json['title'],
      completed: json['completed'],
    );
  }

  static List<Todo> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Todo>((dynamic d) => Todo.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Todo todo) {
    return {
      'userId': todo.userId,
      'title': todo.title,
      'deadline': todo.deadline,
      'description': todo.description,
      'edit': todo.edit,
      'notification': todo.notification,
      'completed': todo.completed,
    };
  }
}

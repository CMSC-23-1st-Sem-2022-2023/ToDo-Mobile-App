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
import 'package:week7_networking_discussion/api/firebase_todo_api.dart';
import 'package:week7_networking_discussion/models/todo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoListProvider with ChangeNotifier {
  late FirebaseTodoAPI firebaseService;
  late Stream<QuerySnapshot> _todosStream;
  Todo? _selectedTodo;

  TodoListProvider() {
    firebaseService = FirebaseTodoAPI();
    fetchTodos();
  }

  void getTodos() {
    firebaseService.getTodos();
  }

  // getter
  Stream<QuerySnapshot> get todos => _todosStream;
  Todo get selected => _selectedTodo!;

  changeSelectedTodo(Todo item) {
    _selectedTodo = item;
  }

  void fetchTodos() {
    _todosStream = firebaseService.getAllTodos();
    notifyListeners();
  }

  // Function for adding a todo
  void addTodo(Todo item) async {
    String message = await firebaseService.addTodo(item.toJson(item), item);
    print(message);
    notifyListeners();
  }

  // Function for editing a todo
  void editTodo(Todo item) async {
    // _todoList[index].title = newTitle;
    String message = await firebaseService.editTodo(_selectedTodo!.id, item);
    print("Edit");
    notifyListeners();
  }

  // Function for deleting a todo
  void deleteTodo() async {
    String message = await firebaseService.deleteTodo(_selectedTodo!.id);
    print(message);
    notifyListeners();
  }

  // Function for changing a todo status
  void toggleStatus(int index, bool status) async {
    // _todoList[index].completed = status;
    _selectedTodo!.completed = status;
    String message = await firebaseService.changeStatusTodo(
        _selectedTodo!.id, _selectedTodo!);
    print(message);
    notifyListeners();
  }
}

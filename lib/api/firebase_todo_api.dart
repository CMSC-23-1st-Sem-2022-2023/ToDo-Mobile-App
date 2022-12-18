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
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:week7_networking_discussion/models/todo_model.dart';
import 'package:week7_networking_discussion/screens/todo_page.dart';
import 'firebase_user_api.dart';

class FirebaseTodoAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final todo = FirebaseFirestore.instance.collection('todos');
  //Uncomment for testing
  //final db = FakeFirebaseFirestore();

  Future<void> getTodos() async {
    TodoPage.isStart = true;
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await todo.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    // Get each todo and save to an array in the todo page
    for (int i = 0; i < allData.length; i++) {
      Todo newTodo = Todo.fromJson(allData[i] as Map<String, dynamic>);
      TodoPage.alltodos.add(newTodo);

      if (TodoPage.user!.todos.contains(newTodo.id) ||
          TodoPage.user!.friends.contains(newTodo.userId)) {
        TodoPage.todos.add(newTodo);
      }
      //print(newTodo.title);
    }
    print('todo length: ${TodoPage.todos.length}');
    TodoPage.func!();
  }

  // Function for adding a todo
  Future<String> addTodo(Map<String, dynamic> todo, Todo currentTodo) async {
    try {
      final docRef = await db.collection("todos").add(todo);
      await db.collection("todos").doc(docRef.id).update({'id': docRef.id});
      TodoPage.user!.todos.add(docRef.id);
      currentTodo.id = docRef.id;
      FirebaseUserAPI().addTodo(TodoPage.user!.id, TodoPage.user!.todos);

      return "Successfully added todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  // Function for getting all todos
  Stream<QuerySnapshot> getAllTodos() {
    return db.collection("todos").snapshots();
  }

  // Function for deleting todo
  Future<String> deleteTodo(String? id) async {
    try {
      await db.collection("todos").doc(id).delete();
      FirebaseUserAPI().deleteTodo(TodoPage.user!.id, TodoPage.user!.todos);

      return "Successfully deleted todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  // Function for changing status of the todo
  Future<String> changeStatusTodo(String? id, Todo todo) async {
    try {
      final docRef = db.collection('todos').doc(id);
      await docRef.update({'completed': todo.completed});

      return "Toggle Status";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> editTodo(String? id, Todo todo) async {
    try {
      final docRef = db.collection('todos').doc(id);
      await docRef.update({'deadline': todo.deadline});
      await docRef.update({'title': todo.title});
      await docRef.update({'description': todo.description});
      await docRef.update({'edit': todo.edit});

      return "Toggle Status";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
}

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
import 'package:week7_networking_discussion/models/todo_model.dart';
import 'package:week7_networking_discussion/models/user_model.dart';
import 'package:week7_networking_discussion/providers/todo_provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/providers/user_provider.dart';
import 'package:week7_networking_discussion/screens/modal_todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week7_networking_discussion/api/notification_api.dart';

class TodoPage extends StatefulWidget {
  TodoPage({super.key});

  // Variable initialization
  static List<User> users = [];
  static List<Todo> todos = [];
  static List<Todo> alltodos = [];
  static User? user = null;
  static Function? func;
  static bool isStart = false;

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late final NotificationApi service;

  @override
  void initState() {
    super.initState();
    service = NotificationApi();
    service.intialize();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> todosStream = context.watch<TodoListProvider>().todos;
    TodoPage.func = refresh;

    // If the user is newly logged in get all users and todos
    if (!TodoPage.isStart) {
      UserListProvider().getUsers();
      TodoListProvider().getTodos();
    }

    return Scaffold(
      // App drawer
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Color(0xFFFFC107),
          ),
          child: Text('Todo App'),
        ),
        ListTile(
          leading: Icon(Icons.task),
          title: const Text('Todos'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: const Text('Profile'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/profile');
          },
        ),
        ListTile(
          leading: Icon(Icons.people),
          title: const Text('Friends'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/friends');
          },
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () {
            context.read<AuthProvider>().signOut();
            Navigator.pop(context);
          },
        ),
      ])),
      appBar: AppBar(
        title: const Text(
          "Todo",
          key: Key('todoTitle'),
        ),
      ),
      body: StreamBuilder(
        stream: todosStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error encountered! ${snapshot.error}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting ||
              TodoPage.user == Null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text("No Todos Found"),
            );
          }

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: TodoPage.todos.length,
            itemBuilder: ((context, index) {
              Todo todo = TodoPage.todos[index];

              return Card(
                margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
                color: Color(0xFFFFC107),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 10.0,
                shadowColor: Colors.black,
                child: ListTile(
                  onTap: () {
                    // Show deadline when the todo is tapped
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Deadline: ${todo.deadline}.')));
                  },
                  title: Text(todo.title),
                  subtitle: Text(todo.description),
                  // Checkbox for todo status
                  leading: Checkbox(
                    activeColor: Color(0xFF212121),
                    value: todo.completed,
                    onChanged: (bool? value) {
                      // If the user is the owner of todo, change the status, else, show a snackbar
                      if (TodoPage.user!.todos.contains(todo.id)) {
                        context
                            .read<TodoListProvider>()
                            .changeSelectedTodo(todo);
                        context
                            .read<TodoListProvider>()
                            .toggleStatus(index, value!);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('This is not your todo.')));
                      }
                    },
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          // Edit the todo
                          context
                              .read<TodoListProvider>()
                              .changeSelectedTodo(todo);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => TodoModal(
                              type: 'Edit',
                              todo: todo,
                              service: service,
                            ),
                          );
                        },
                        icon: const Icon(Icons.create_outlined),
                      ),
                      IconButton(
                        onPressed: () {
                          // Delete the todo
                          if (TodoPage.user!.todos.contains(todo.id)) {
                            context
                                .read<TodoListProvider>()
                                .changeSelectedTodo(todo);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => TodoModal(
                                type: 'Delete',
                                todo: todo,
                                service: service,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('This is not your todo.')));
                          }
                        },
                        icon: const Icon(Icons.delete_outlined),
                      )
                    ],
                  ),
                ),
              );
            }),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFFFC107),
        onPressed: () {
          // Add a todo
          showDialog(
            context: context,
            builder: (BuildContext context) => TodoModal(
              type: 'Add',
              todo: null,
              service: service,
            ),
          );
        },
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}

/*
  Created by: Claizel Coubeili Cepe
  Date: 27 October 2022
  Description: Sample todo app with networking
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

class TodoPage extends StatefulWidget {
  TodoPage({super.key});
  //String? userEmail = AuthProvider.userObj!.email;
  static List<User> users = [];
  static List<Todo> todos = [];
  static User? user;
  static bool isStart = false;

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    //TodoPage.todos = [];
    //TodoPage.users = [];
    // access the list of todos in the provider
    Stream<QuerySnapshot> todosStream = context.watch<TodoListProvider>().todos;
    //context.read<UserListProvider>().getUsers;

    if (!TodoPage.isStart) {
      UserListProvider().getUsers();
      TodoListProvider().getTodos();
    }

    /*while (TodoPage.users.length == 0) {
      print("1");
    }*/

    //
    // How to wait the upper code first before doing this??
    //
    return Scaffold(
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
        ListTile(
          title: const Text('Todos'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('Profile'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/profile');
          },
        ),
        ListTile(
          title: const Text('Friends'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/friends');
          },
        ),
        ListTile(
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
                shadowColor: Colors.grey,
                child:
                    /* return Dismissible(
                key: Key(todo.id.toString()),
                onDismissed: (direction) {
                  context.read<TodoListProvider>().changeSelectedTodo(todo);
                  context.read<TodoListProvider>().deleteTodo();

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${todo.title} dismissed')));
                },
                background: Container(
                  color: Colors.red,
                  child: const Icon(Icons.delete),
                ), */
                    ListTile(
                  title: Text(todo.title),
                  subtitle: Text(todo.description),
                  leading: Checkbox(
                    value: todo.completed,
                    onChanged: (bool? value) {
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
                          // showDialog(
                          //   context: context,
                          //   builder: (BuildContext context) => TodoModal(
                          //     type: 'Edit',
                          //     todoIndex: index,
                          //   ),
                          // );
                        },
                        icon: const Icon(Icons.create_outlined),
                      ),
                      IconButton(
                        onPressed: () {
                          if (TodoPage.user!.todos.contains(todo.id)) {
                            context
                                .read<TodoListProvider>()
                                .changeSelectedTodo(todo);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => TodoModal(
                                type: 'Delete',
                                todo: todo,
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
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => TodoModal(
              type: 'Add',
              todo: null,
            ),
          );
        },
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}

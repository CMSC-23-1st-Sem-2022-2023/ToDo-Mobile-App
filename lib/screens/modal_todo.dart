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
import 'package:week7_networking_discussion/providers/todo_provider.dart';
import 'package:week7_networking_discussion/providers/user_provider.dart';
import 'package:week7_networking_discussion/screens/todo_page.dart';
import 'package:week7_networking_discussion/api/notification_api.dart';

class TodoModal extends StatefulWidget {
  String type = '';
  Todo? todo;
  late final NotificationApi service;

  TodoModal(
      {super.key,
      required this.type,
      required this.todo,
      required this.service});
  @override
  _TodoModalState createState() => _TodoModalState();
}

class _TodoModalState extends State<TodoModal> {
  // int todoIndex;

  TextEditingController _formFieldController = TextEditingController();
  DateTime date = DateTime.now();
  DateTime now = DateTime.now();
  String deadlineDate = '';
  bool isCompleted = false;
  bool notification = false;
  String edit = '';
  TextEditingController _descriptionController = TextEditingController();

  // Method to show the title of the modal depending on the functionality
  Widget _buildTitle() {
    switch (widget.type) {
      case 'Add':
        return const Center(child: Text("Add new todo"));
      case 'Edit':
        return const Center(child: Text("Edit todo"));
      case 'Delete':
        return const Center(child: Text("Delete todo"));
      default:
        return const Text("");
    }
  }

  // Method to build the content or body depending on the functionality
  Widget _buildContent(BuildContext context) {
    // Status checkbox
    final status = Row(children: [
      Text("Completed: "),
      Checkbox(
        value: isCompleted,
        onChanged: (bool? value) {
          setState(() {
            isCompleted = value!;
          });
        },
      )
    ]);

    // Notif checkbox
    final notif = Row(children: [
      Icon(Icons.notifications_active),
      Text(' : '),
      Checkbox(
        value: notification,
        onChanged: (bool? value) {
          setState(() {
            notification = value!;
          });
        },
      )
    ]);

    //Deadline field
    final deadline = Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () async {
              DateTime? newDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100));
              if (newDate == null) return;
              deadlineDate =
                  "${newDate.year.toString()}/${newDate.month.toString()}/${newDate.day.toString()}";
              setState(() => date = newDate);
            },
          ),
          Text(
            '  Deadline: ${date.year}/${date.month}/${date.day}',
            key: const Key('deadlineField'),
          )
        ],
      ),
    );

    switch (widget.type) {
      case 'Delete':
        {
          return Text(
            "Are you sure you want to delete '${context.read<TodoListProvider>().selected.title}'?",
          );
        }
      case 'Add':
        {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              deadline,
              TextField(
                controller: _formFieldController,
                decoration: const InputDecoration(
                    labelText: 'Title',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                    labelText: 'Description',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  status,
                  SizedBox(
                    width: 20,
                  ),
                  notif
                ],
              )
            ],
          );
        }
      // Edit and add will have input field in them
      default:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Last edit: ${widget.todo!.edit}'),
            deadline,
            TextField(
              controller: _formFieldController,
              decoration: const InputDecoration(
                  labelText: 'Title',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  border: OutlineInputBorder()),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                  labelText: 'Description',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  border: OutlineInputBorder()),
            ),
          ],
        );
    }
  }

  // Function for showing notification
  void showNotif(int task, String title) async {
    if (task == 0) {
      await widget.service.showNotification(
          id: 0, title: 'Todo', body: 'A new todo has been added');
    } else if (task == 1) {
      await widget.service.showNotification(
          id: 0, title: 'Todo', body: '$title has been deleted.');
    } else {
      await widget.service.showNotification(
          id: 0, title: 'Todo', body: '$title has been edited.');
    }
  }

  TextButton _dialogAction(BuildContext context) {
    return TextButton(
      onPressed: () {
        switch (widget.type) {
          case 'Add':
            {
              // For adding a new todo
              // Instantiate a todo object to be inserted

              if (deadlineDate.length == 0) {
                deadlineDate =
                    '${date.year.toString()}/${date.month.toString()}/${date.day.toString()}';
              }

              Todo temp = Todo(
                  userId: TodoPage.user!.id,
                  deadline: deadlineDate,
                  notification: notification,
                  description: _descriptionController.text,
                  edit:
                      '${TodoPage.user!.name} - ${now.month.toString()}/${now.day.toString()} ${now.hour.toString()}:${now.minute.toString()}',
                  completed: isCompleted,
                  title: _formFieldController.text);

              TodoPage.todos.add(temp);
              context.read<TodoListProvider>().addTodo(temp);

              if (temp.notification == true) {
                showNotif(0, temp.title);
              }

              //context.read<UserListProvider>().addTodo(TodoPage.user!.todos);

              // Remove dialog after adding
              Navigator.of(context).pop();
              break;
            }
          case 'Edit':
            {
              // For editing a todo
              if (deadlineDate.length == 0) {
                deadlineDate =
                    '${date.year.toString()}/${date.month.toString()}/${date.day.toString()}';
              }

              widget.todo!.edit =
                  '${TodoPage.user!.name} - ${now.month.toString()}/${now.day.toString()} ${now.hour.toString()}:${now.minute.toString()}';
              widget.todo!.title = _formFieldController.text;
              widget.todo!.description = _descriptionController.text;
              widget.todo!.deadline = deadlineDate;

              context.read<TodoListProvider>().editTodo(widget.todo!);

              if (widget.todo!.notification == true) {
                showNotif(2, widget.todo!.title);
              }

              // Remove dialog after editing
              Navigator.of(context).pop();
              break;
            }
          case 'Delete':
            {
              // For deleting a todo
              TodoPage.todos.remove(widget.todo);
              TodoPage.user!.todos.remove(widget.todo!.id);
              context.read<TodoListProvider>().deleteTodo();

              if (widget.todo!.notification == true) {
                showNotif(1, widget.todo!.title);
              }

              // Remove dialog after editing
              Navigator.of(context).pop();
              break;
            }
        }
      },
      style: TextButton.styleFrom(
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      child: Text(widget.type),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildTitle(),
      content: _buildContent(context),

      // Contains two buttons - add/edit/delete, and cancel
      actions: <Widget>[
        _dialogAction(context),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ],
    );
  }
}

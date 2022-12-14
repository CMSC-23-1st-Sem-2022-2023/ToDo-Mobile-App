/*
  Created by: Claizel Coubeili Cepe
  Date: 27 October 2022
  Description: Sample todo app with networking
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/models/todo_model.dart';
import 'package:week7_networking_discussion/providers/todo_provider.dart';
import 'package:week7_networking_discussion/providers/user_provider.dart';
import 'package:week7_networking_discussion/screens/todo_page.dart';

class TodoModal extends StatefulWidget {
  String type = '';
  Todo? todo;

  TodoModal({super.key, required this.type, required this.todo});
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
        return const Text("Edit todo");
      case 'Delete':
        return const Text("Delete todo");
      default:
        return const Text("");
    }
  }

  // Method to build the content or body depending on the functionality
  Widget _buildContent(BuildContext context) {
    // Use context.read to get the last updated list of todos
    // List<Todo> todoItems = context.read<TodoListProvider>().todo;

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

    final notif = Row(children: [
      Text("Notification: "),
      Checkbox(
        value: notification,
        onChanged: (bool? value) {
          setState(() {
            notification = value!;
          });
        },
      )
    ]);

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
              SizedBox(height: 10),
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
                children: [status, notif],
              )
            ],
          );
        }
      // Edit and add will have input field in them
      default:
        return TextField(
          controller: _formFieldController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            // hintText: todoIndex != -1 ? todoItems[todoIndex].title : '',
          ),
        );
    }
  }

  TextButton _dialogAction(BuildContext context) {
    // List<Todo> todoItems = context.read<TodoListProvider>().todo;

    return TextButton(
      onPressed: () {
        switch (widget.type) {
          case 'Add':
            {
              // Instantiate a todo objeect to be inserted, default userID will be 1, the id will be the next id in the list
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
              //context.read<UserListProvider>().addTodo(TodoPage.user!.todos);

              // Remove dialog after adding
              Navigator.of(context).pop();
              break;
            }
          case 'Edit':
            {
              //context
              //  .read<TodoListProvider>()
              //.editTodo(todoIndex, _formFieldController.text);

              // Remove dialog after editing
              Navigator.of(context).pop();
              break;
            }
          case 'Delete':
            {
              TodoPage.todos.remove(widget.todo);
              TodoPage.user!.todos.remove(widget.todo!.id);
              context.read<TodoListProvider>().deleteTodo();

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

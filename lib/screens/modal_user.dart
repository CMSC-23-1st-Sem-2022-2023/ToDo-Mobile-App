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

import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/models/user_model.dart';
import 'package:week7_networking_discussion/providers/user_provider.dart';
import 'package:week7_networking_discussion/screens/friends_page.dart';
import 'package:week7_networking_discussion/screens/todo_page.dart';

class UserModal extends StatelessWidget {
  User user;
  User otherUser;
  String type;
  List<User> requests;
  TextEditingController _formFieldController = TextEditingController();

  UserModal({
    super.key,
    required this.otherUser,
    required this.user,
    required this.type,
    required this.requests,
  });

  // Method to show the title of the modal depending on the functionality
  Text _buildTitle() {
    switch (type) {
      case 'Add':
        return const Text("Add new todo");
      case 'Edit':
        return const Text("Edit todo");
      case 'Delete':
        return const Text("Delete friend");
      default:
        return const Text("");
    }
  }

  // Method to build the content or body depending on the functionality
  Widget _buildContent(BuildContext context) {
    switch (type) {
      case 'Delete':
        {
          // For deleting a friend
          return Column(mainAxisSize: MainAxisSize.min, children: [
            const Padding(
                padding: EdgeInsets.all(30),
                child: Center(
                    child: Text(
                  "Are you sure you want to delete this friend?",
                ))),
            ElevatedButton(
              onPressed: () {
                for (int i = 0; i < TodoPage.todos.length; i++) {
                  if (otherUser.todos.contains(TodoPage.todos[i].id)) {
                    TodoPage.todos.remove(TodoPage.todos[i]);
                  }
                }

                TodoPage.user!.friends.remove(otherUser.id);
                otherUser.friends.remove(TodoPage.user!.id);

                FriendsPage.friends.remove(otherUser);

                context
                    .read<UserListProvider>()
                    .deleteFriend(user.friends, otherUser.friends);

                FriendsPage.refresher!();
                TodoPage.func!();
                // Remove dialog after delete
                Navigator.of(context).pop();
              },
              child: Text("Delete"),
            ),
            SizedBox(
              height: 20,
            ),
          ]);
        }
      case 'request':
        {
          // For requesting to a friend
          int length = user.receivedFriendRequests.length;
          List<User> friendrequests = requests;

          return ListView.builder(
            itemCount: length,
            itemBuilder: ((context, index) {
              User other = friendrequests[index];
              print(length);

              return ListTile(
                title: Text(other.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        for (int i = 0; i < TodoPage.alltodos.length; i++) {
                          if (other.todos.contains(TodoPage.alltodos[i].id)) {
                            TodoPage.todos.add(TodoPage.alltodos[i]);
                          }
                        }
                        print(TodoPage.todos.length);

                        //Accept request
                        TodoPage.user!.friends.add(other.id);
                        other.friends.add(user.id);
                        FriendsPage.friends.add(other);

                        user.receivedFriendRequests.remove(other.id);
                        other.sentFriendRequests.remove(user.id);
                        friendrequests.remove(other);
                        FriendsPage.requests.remove(other);

                        context.read<UserListProvider>().setUser(user);
                        context.read<UserListProvider>().changeOtherUser(other);

                        context.read<UserListProvider>().deleteRequest(
                            user.receivedFriendRequests,
                            otherUser.sentFriendRequests);

                        context
                            .read<UserListProvider>()
                            .acceptRequest(user.friends, other.friends);

                        TodoPage.func!();
                        FriendsPage.refresher!();
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.check_rounded),
                    ),
                    IconButton(
                      //Decline request
                      onPressed: () {
                        Navigator.of(context).pop();
                        user.receivedFriendRequests.remove(other.id);
                        other.sentFriendRequests.remove(user.id);
                        friendrequests.remove(other);
                        FriendsPage.requests.remove(other);

                        context.read<UserListProvider>().setUser(user);
                        context.read<UserListProvider>().changeOtherUser(other);

                        context.read<UserListProvider>().deleteRequest(
                            user.receivedFriendRequests,
                            other.sentFriendRequests);
                      },
                      icon: const Icon(Icons.clear_rounded),
                    )
                  ],
                ),
              );
            }),
          );
        }
      // Search
      default:
        return Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(
            height: 20,
          ),
          const Center(
              child: Text(
            'Search',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          )),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
              width: 280,
              child: TextField(
                controller: _formFieldController,
                decoration: const InputDecoration(
                    labelText: 'Enter name',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    border: OutlineInputBorder()),
              )),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                showSearch(_formFieldController.text, context);
              },
              child: Text("Search")),
          SizedBox(
            height: 20,
          ),
        ]);
    }
  }

  // Gets the result of search
  void showSearch(String text, BuildContext context) {
    List<User> found = [];
    for (int i = 0; i < TodoPage.users.length; i++) {
      if (TodoPage.users[i].name.toLowerCase().contains(text.toLowerCase()) &&
          TodoPage.users[i].id != TodoPage.user!.id) {
        found.add(TodoPage.users[i]);
      }
    }

    if (found.length == 0) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Container(
                height: 100,
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(40, 33, 0, 0),
                  child: Text(
                    "No friends found",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
                child: ListView.builder(
              itemCount: found.length,
              itemBuilder: ((context, index) {
                otherUser = found[index];
                return ListTile(
                  title: Text(otherUser.name),
                  trailing: IconButton(
                    //Send request
                    onPressed: () {
                      User userToBeAdded = found[index];

                      // If user is already a friend
                      if (user.friends.contains(userToBeAdded.id)) {
                        Flushbar(
                          //backgroundColor: Colors.white,
                          message: 'This user is already your friend.',
                          duration: Duration(seconds: 3),
                        ).show(context);

                        return;
                      } else if (user.sentFriendRequests
                          .contains(userToBeAdded.id)) {
                        // If you already send a friend request to the user
                        Flushbar(
                          //backgroundColor: Colors.white,
                          message:
                              'You already send a friend request to this user.',
                          duration: Duration(seconds: 3),
                        ).show(context);

                        return;
                      } else if (user.receivedFriendRequests
                          .contains(userToBeAdded.id)) {
                        // If user is already in the friend request
                        Flushbar(
                          //backgroundColor: Colors.white,
                          message:
                              'This user is already in your friend request.',
                          duration: Duration(seconds: 3),
                        ).show(context);
                        return;
                      } else {
                        // Else send a friend request
                        user.sentFriendRequests.add(userToBeAdded.id);
                        userToBeAdded.receivedFriendRequests.add(user.id);
                        FriendsPage.requests.add(userToBeAdded);
                        otherUser = userToBeAdded;

                        context.read<UserListProvider>().setUser(user);
                        context
                            .read<UserListProvider>()
                            .changeOtherUser(userToBeAdded);

                        context.read<UserListProvider>().sendRequest(
                            user.sentFriendRequests,
                            userToBeAdded.receivedFriendRequests);

                        Flushbar(
                          //backgroundColor: Colors.white,
                          message: 'Friend request sent!',
                          duration: Duration(seconds: 3),
                        ).show(context);

                        return;
                      }
                    },
                    icon: const Icon(Icons.add),
                  ),
                );
              }),
            ));
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Dialog(
      child: _buildContent(context),
    ));
  }
}

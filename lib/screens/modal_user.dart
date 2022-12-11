/*
  Created by: Roxanne Ysabel Reuslloe
  Date: 11 November 2022
  Description: 
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/models/user_model.dart';
import 'package:week7_networking_discussion/providers/user_provider.dart';
import 'package:week7_networking_discussion/screens/friends_page.dart';

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

  //UserModal.search({super.key, required this.users, required this.type, required this.user});

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
      case 'send':
        {
          return SizedBox(
              height: 30,
              child: Column(children: [
                TextField(
                  controller: _formFieldController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'type username of the user you like to add',
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      sendRequest(_formFieldController.text, context);
                    },
                    child: Text("Add"))
              ]));
        }
      case 'Delete':
        {
          return Column(children: [
            const Padding(
                padding: EdgeInsets.all(30),
                child: Text(
                  "Are you sure you want to delete this friend?",
                )),
            ElevatedButton(
                onPressed: () {
                  context
                      .read<UserListProvider>()
                      .deleteFriend(user.friends, otherUser.friends);

                  // Remove dialog after delete
                  Navigator.of(context).pop();
                },
                child: Text("Delete")),
          ]);
        }
      case 'request':
        {
          int length = user.receivedFriendRequests.length;
          List<User> friendrequests = requests;

          return ListView.builder(
            itemCount: length,
            itemBuilder: ((context, index) {
              User other = friendrequests[index];

              return ListTile(
                title: Text(other.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        //Accept request
                        Navigator.of(context).pop();
                        user.receivedFriendRequests.remove(other.id);
                        other.sentFriendRequests.remove(user.id);
                        friendrequests.remove(other);
                        FriendsPage.requests.remove(other);

                        context.read<UserListProvider>().setUser(user);
                        context.read<UserListProvider>().changeOtherUser(other);

                        user.friends.add(other.id);
                        other.friends.add(user.id);

                        context.read<UserListProvider>().deleteRequest(
                            user.receivedFriendRequests,
                            otherUser.sentFriendRequests);

                        context
                            .read<UserListProvider>()
                            .acceptRequest(user.friends, other.friends);
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
        return Column(children: [
          TextField(
            controller: _formFieldController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: 'type username',
            ),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                showSearch(_formFieldController.text, context);
              },
              child: Text("Search"))
        ]);
    }
  }

  void sendRequest(String text, BuildContext context) {
    List<String> tempUsers = [];
    User userToBeAdded = user;

    for (int i = 0; i < FriendsPage.userLength; i++) {
      //tempUsers.add(FriendsPage.users[i].userName);
      //if (FriendsPage.users[i].userName == text) {
      //  userToBeAdded = FriendsPage.users[i];
      //}
    }

    if (tempUsers.contains(text)) {
      if (user.friends.contains(userToBeAdded.id)) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('This user is already your friend.')));

        return;
      }

      if (user.sentFriendRequests.contains(userToBeAdded.id)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('You already sent a request to this user.')));

        return;
      }

      user.sentFriendRequests.add(userToBeAdded.id);
      userToBeAdded.receivedFriendRequests.add(user.id);
      FriendsPage.requests.add(userToBeAdded);
      otherUser = userToBeAdded;

      context.read<UserListProvider>().setUser(user);
      context.read<UserListProvider>().changeOtherUser(userToBeAdded);

      context.read<UserListProvider>().sendRequest(
          user.sentFriendRequests, userToBeAdded.receivedFriendRequests);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Friend request sent')));
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('No user found.')));
  }

  void showSearch(String text, BuildContext context) {
    List<User> found = [];
    for (int i = 0; i < user.friends.length; i++) {
      /* if (FriendsPage.friends[i].userName.contains(text)) {
        found.add(FriendsPage.friends[i]);
      } */
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

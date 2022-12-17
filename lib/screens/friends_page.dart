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
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/models/todo_model.dart';
import 'package:week7_networking_discussion/models/user_model.dart';
import 'package:week7_networking_discussion/providers/user_provider.dart';
import 'package:week7_networking_discussion/screens/modal_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week7_networking_discussion/screens/profile_page.dart';
import 'package:week7_networking_discussion/screens/todo_page.dart';
import 'friends_profile.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  // Variable declaration
  static List<User> requests = [];
  static List<User> friends = [];
  static int userLength = TodoPage.users.length;
  static bool isLoaded = false;

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friends"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Show dialog for searching a friend
              showDialog(
                context: context,
                builder: (BuildContext context) => UserModal(
                  otherUser: TodoPage.user!,
                  user: TodoPage.user!,
                  type: 'search',
                  requests: [],
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: TodoPage.user!.friends.length,
        itemBuilder: (context, index) {
          User friend = FriendsPage.friends[index];

          // Return a list tile for each friend
          return ListTile(
            title: Text(friend.name),
            onTap: () {
              // Go to friends profile when list tile is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FriendsProfile(
                          name: friend.name,
                          location: friend.location,
                          bio: friend.bio,
                          birthday: friend.birthday,
                          email: friend.email,
                        )),
              );
            },
            trailing: IconButton(
              onPressed: () {
                // For deleting a friend
                context.read<UserListProvider>().setUser(TodoPage.user!);
                context.read<UserListProvider>().changeOtherUser(friend);
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      TodoPage.user!.friends.remove(friend.id);
                      friend.friends.remove(TodoPage.user!.id);

                      return UserModal(
                        otherUser: friend,
                        user: TodoPage.user!,
                        type: 'Delete',
                        requests: [],
                      );
                    });
              },
              icon: const Icon(Icons.delete_outlined),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Go to a dialog where requests are shown
          showDialog(
            context: context,
            builder: (BuildContext context) => UserModal(
              otherUser: TodoPage.user!,
              user: TodoPage.user!,
              type: 'request',
              requests: FriendsPage.requests,
            ),
          );
        },
        child: const Icon(Icons.people),
      ),
    );
  }
}

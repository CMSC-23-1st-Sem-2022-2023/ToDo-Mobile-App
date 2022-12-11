/*
  Created by: Roxanne Ysabel Resuello
  Date: 11 November 2022
  Description: Sample todo app with networking
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
  //static User? user;
  //static List<User> users = [];
  static List<User> requests = [];
  static List<User> friends = [];
  static int userLength = TodoPage.users.length;
  //static bool isLoaded = false;
  //static Stream<QuerySnapshot>? usersStream;

  /* final _FriendsPageState vpcs = _FriendsPageState();
  vpcs.getLength; */

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    /*
    return Scaffold(
      appBar: AppBar(title: Text("Friends")),
    );
    // access the list of users in the provider
    */
    Stream<QuerySnapshot> usersStream =
        context.watch<UserListProvider>().users.asBroadcastStream();
    //FriendsPage.usersStream = usersStream;
    /* List<User> users = [];
    usersStream.forEach((doc) {
      print(5);
      print(doc);
      User.fromJson(doc.docs[0].data() as Map<String, dynamic>);
    }); */

    //for (QuerySnapshot<Object> docs in usersStream) {}

    //print(users.length);

    /*
    Future<int> getLength() async {
      final length = await UserListProvider().getLength();
      return length;
    }

    getLength().then((value) {
      FriendsPage.userLength = value;
      FriendsPage.isLoaded = true;
    });
    */

    //sersStream.

    //UserListProvider();
    //List<User> users = usersStream.forEach((doc) => {User.fromJson(doc as Map<String, dynamic>)});
    //User user = context.watch<UserListProvider>().selected;
    //print(usersStream);

    return Scaffold(
      appBar: AppBar(
        title: Text("Friends"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => UserModal(
                  otherUser: TodoPage.user!,
                  user: TodoPage.user!,
                  type: 'send',
                  requests: [],
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
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
        //future: FriendsPage.usersStream,
        itemBuilder: (context, index) {
          //FriendsPage.requests = [];
          //FriendsPage.friends = [];
          print(TodoPage.user!.friends.length);

          /* if (snapshot.hasError) {
            return Center(
              child: Text("Error encountered! ${snapshot.error}"),
            );
          } else if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data?.docs.length == 1 ||
              TodoPage.user!.friends.length == 0) {
            return Center(
              child: Text("No Friends Found"),
            );
          } */

          if (TodoPage.user!.friends.isEmpty) {
            return const Center(
              child: Text("No Friends Found"),
            );
          }

          /* User user = User.fromJson(
              snapshot.data?.docs.first.data() as Map<String, dynamic>);
          FriendsPage.user = user; */

          //int length = TodoPage.user!.friends.length;
          //List<User> friends = [];

          /* for (int i = 0; i < FriendsPage.userLength; i++) {
            User checkUser = User.fromJson(
                snapshot.data?.docs[i].data() as Map<String, dynamic>);
            FriendsPage.users.add(checkUser);
            if (user.friends.contains(checkUser.id)) {
              friends.add(checkUser);
            }
          } */

          //FriendsPage.friends = friends;
/* 
          for (int i = 0; i < FriendsPage.userLength; i++) {
            User checkUser = User.fromJson(
                snapshot.data?.docs[i].data() as Map<String, dynamic>);
            if (user.receivedFriendRequests.contains(checkUser.id)) {
              FriendsPage.requests.add(checkUser);
            }
          } */

          /* print('start');
          for (int i = 0; i < FriendsPage.requests.length; i++) {
            print(FriendsPage.requests[i].displayName);
          }
          print('end'); */

          /*return ListView.builder(
            itemCount: length,
            itemBuilder: ((context, index) {*/
          User friend = FriendsPage.friends[index];
          return ListTile(
            title: Text(friend.name),
            /* leading: Checkbox(
                    value: todo.completed,
                    onChanged: (bool? value) {
                      context.read<UserListProvider>().changeSelectedTodo(user);
                      //context.read<UserListProvider>().toggleStatus(value!);
                    }, 
                  ),*/
            onTap: () {
              //print(friend.name);
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
          //navigate to AddTaskPage page and automatically calls the setState()
          //to render newly added task in textfile when Navigator.pop is called from AddTaskPage page
          //Navigator.of(context).pushNamed('/request');
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

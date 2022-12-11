import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week7_networking_discussion/models/todo_model.dart';
import 'package:week7_networking_discussion/screens/friends_page.dart';
import 'package:week7_networking_discussion/models/user_model.dart';
import 'package:week7_networking_discussion/screens/todo_page.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';

class FirebaseUserAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final users = FirebaseFirestore.instance.collection('users');

  //inal docRef = db.collection("users").doc('kuND0KXmc148REGSIL5G');

  /*
  Future<String> addUser(Map<String, dynamic> todo) async {
    try {
      final docRef = await db.collection("users").add(todo);
      await db.collection("todos").doc(docRef.id).update({'id': docRef.id});

      return "Successfully added the user!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
  */

  Stream<QuerySnapshot> getAllUsers() {
    return db.collection("users").snapshots();
  }

  /*void getUsers() async {
    await users.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        User user = User.fromJson(doc.data() as Map<String, dynamic>);
        print("hi");
      });
    });
  }*/
/*
  Future<void> setCurrentUser(String email) async {
    QuerySnapshot querySnapshot =
        await users.where('email', isEqualTo: email).get();

    /*for (var snapshot in querySnapshot.docs) {
      Map<String, dynamic> data = snapshot.data() as M;
    }*/
    print("object");
    TodoPage.user =
        User.fromJson(querySnapshot.docs[0].data() as Map<String, dynamic>);
    print(TodoPage.user!.name);
  }
  */

  Future<void> getUsers() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await users.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    //print(allData);

    for (int i = 0; i < allData.length; i++) {
      User newUser = User.fromJson(allData[i] as Map<String, dynamic>);
      TodoPage.users.add(newUser);
      print(newUser.email);
    }

    print(TodoPage.users.length);
    for (int i = 0; i < TodoPage.users.length; i++) {
      //print(TodoPage.users[i].email);
      if (TodoPage.users[i].email == AuthProvider.userObj!.email) {
        TodoPage.user = TodoPage.users[i];
        print("here");
        print(TodoPage.user!.name);
      }
    }

    // Get friends
    for (int i = 0; i < TodoPage.users.length; i++) {
      User checkUser = TodoPage.users[i];

      if (TodoPage.user!.friends.contains(checkUser.id)) {
        FriendsPage.friends.add(checkUser);
      }
    }

    //Get friend request
    for (int i = 0; i < FriendsPage.userLength; i++) {
      User checkUser = TodoPage.users[i];
      if (TodoPage.user!.receivedFriendRequests.contains(checkUser.id)) {
        FriendsPage.requests.add(checkUser);
      }
    }
    print('friends ${FriendsPage.friends.length}');
  }

/* 
  void tryy(){
    final FirebaseUser cuser = await auth.currentUser();
final userid = cuser.uid;
  } */

  Future<int> getLength() async {
    var length = await db.collection('users').get().then((querySnapshot) {
      FriendsPage.userLength = querySnapshot.size;
      FriendsPage.isLoaded = true;
    });
    return length;
  }

  Future<String> deleteFriend(String? id, List<dynamic> friends) async {
    try {
      final docRef = db.collection('users').doc(id);
      await docRef.update({'friends': friends});

      return "Successfully deleted a friend!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> acceptRequest(String? id, List<dynamic> friends) async {
    try {
      final docRef = db.collection('users').doc(id);
      await docRef.update({'friends': friends});

      return "Successfully accepted a friend!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> sendRequest(String? id, List<dynamic> sent) async {
    try {
      final docRef = db.collection('users').doc(id);
      await docRef.update({'sentFriendRequests': sent});

      return "Successfully sent a friend!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> receiveRequest(String? id, List<dynamic> received) async {
    try {
      final docRef = db.collection('users').doc(id);
      await docRef.update({'receivedFriendRequests': received});

      return "Successfully received a friend!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> deleteRequest(String? id, List<dynamic> received) async {
    try {
      print(id);
      final docRef = db.collection('users').doc(id);
      await docRef.update({'receivedFriendRequests': received});

      return "Successfully updated received request!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> deleteSent(String? id, List<dynamic> sent) async {
    try {
      print(id);
      final docRef = db.collection('users').doc(id);
      await docRef.update({'sentFriendRequests': sent});

      return "Successfully updated sent request!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
}

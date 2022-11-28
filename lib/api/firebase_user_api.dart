import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week7_networking_discussion/models/todo_model.dart';
import 'package:week7_networking_discussion/screens/friends_page.dart';
import 'package:week7_networking_discussion/models/user_model.dart';
import 'package:week7_networking_discussion/screens/todo_page.dart';

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
    //print(TodoPage.users);
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

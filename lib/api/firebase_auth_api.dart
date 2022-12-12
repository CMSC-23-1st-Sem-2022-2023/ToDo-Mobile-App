import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:week7_networking_discussion/screens/login.dart';

class FirebaseAuthAPI {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static bool wrongEmail = false;
  static bool wrongPass = false;
  static bool alreadeyExist = false;

  // Uncomment for testing
  /* final db = FakeFirebaseFirestore();

  final auth = MockFirebaseAuth(
      mockUser: MockUser(
    isAnonymous: false,
    uid: 'someuid',
    email: 'charlie@paddyspub.com',
    displayName: 'Charlie',
  )); */

  void saveUserToFirestore(String? uid, String birthday, String email,
      String name, String location, String bio) async {
    try {
      List<String> friends = [];
      List<String> sentFriendRequests = [];
      List<String> receivedFriendRequests = [];
      List<String> todos = [];
      await db.collection("users").doc(uid).set({
        "id": uid,
        "birthday": birthday,
        "email": email,
        "name": name,
        "location": location,
        "bio": bio,
        "todos": todos,
        "friends": friends,
        "sentFriendRequests": sentFriendRequests,
        "receivedFriendRequests": receivedFriendRequests
      });
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  Stream<User?> getUser() {
    return auth.authStateChanges();
  }

  void signIn(String email, String password) async {
    UserCredential credential;
    try {
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseAuthAPI.wrongEmail = false;
      FirebaseAuthAPI.wrongPass = false;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        FirebaseAuthAPI.wrongEmail = true;
        //possible to return something more useful
        //than just print an error message to improve UI/UX
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        FirebaseAuthAPI.wrongPass = true;
        print('Wrong password provided for that user.');
      }
    }
  }

  void signUp(String name, String birthday, String bio, String location,
      String email, String password) async {
    UserCredential credential;
    try {
      credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        saveUserToFirestore(
            credential.user?.uid, birthday, email, name, location, bio);
      }
    } on FirebaseAuthException catch (e) {
      //possible to return something more useful
      //than just print an error message to improve UI/UX
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        FirebaseAuthAPI.alreadeyExist = true;
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  void signOut() async {
    auth.signOut();
  }
}

import 'dart:convert';

class User {
  final String id;
  String userName;
  String displayName;
  List<dynamic> friends;
  List<dynamic> receivedFriendRequests;
  List<dynamic> sentFriendRequests;

  User(
      {required this.id,
      required this.userName,
      required this.displayName,
      required this.friends,
      required this.receivedFriendRequests,
      required this.sentFriendRequests});

  // Factory constructor to instantiate object from json format
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userName: json['userName'],
      displayName: json['displayName'],
      friends: json['friends'],
      receivedFriendRequests: json['receivedFriendRequests'],
      sentFriendRequests: json['sentFriendRequests'],
    );
  }

  static List<User> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<User>((dynamic d) => User.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(User user) {
    return {
      'id': user.id,
      'userName': user.userName,
      'displayName': user.displayName,
      'friends': user.friends,
      'receivedFriendRequests': user.receivedFriendRequests,
      'sentFriendRequests': user.sentFriendRequests,
    };
  }
}

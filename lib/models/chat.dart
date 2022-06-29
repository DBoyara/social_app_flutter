import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String userId;
  final String userName;
  final Timestamp time;
  final String message;

  Chat({
    required this.userId,
    required this.userName,
    required this.time,
    required this.message,
  });
}

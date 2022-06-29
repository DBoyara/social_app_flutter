import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String userId;
  final String userName;
  final Timestamp time;
  final String imageURL;
  final String description;

  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.time,
    required this.imageURL,
    required this.description,
  });
}

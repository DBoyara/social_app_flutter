import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/chat.dart';

class MessageListTile extends StatelessWidget {
  final Chat chat;

  MessageListTile(this.chat);

  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            bottomLeft: chat.userId == currentUserId
                ? const Radius.circular(15)
                : Radius.zero,
            topRight: const Radius.circular(15),
            bottomRight: chat.userId == currentUserId
                ? Radius.zero
                : const Radius.circular(15),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: chat.userId == currentUserId
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            mainAxisAlignment: chat.userId == currentUserId
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Text(
                "By ${chat.userName}",
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                chat.message,
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}

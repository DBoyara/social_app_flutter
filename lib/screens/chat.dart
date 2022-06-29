import 'package:app_09/models/post.dart';
import 'package:app_09/models/chat.dart';
import 'package:app_09/widgets/message_list_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  static const String id = "/chat";

  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final String _currentUserId = FirebaseAuth.instance.currentUser!.uid;
  String _message = "";
  late TextEditingController _editingController;

  @override
  void initState() {
    _editingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Post post = ModalRoute.of(context)!.settings.arguments as Post;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("posts")
                      .doc(post.id)
                      .collection("comments").orderBy("timestamp")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("error"),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.connectionState == ConnectionState.none) {
                      return const Center(
                        child: Text("loading"),
                      );
                    }
                    return ListView.builder(
                        itemCount: snapshot.data?.docs.length ?? 0,
                        itemBuilder: (context, index) {
                          final QueryDocumentSnapshot doc =
                              snapshot.data!.docs[index];

                          final Chat chat = Chat(
                            userId: doc["userId"],
                            message: doc["message"],
                            userName: doc["userName"],
                            time: doc["timestamp"],
                          );

                          return Align(
                              alignment: chat.userId == _currentUserId
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: MessageListTile(chat));
                        });
                  }),
            ),
            SizedBox(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: TextField(
                      controller: _editingController,
                      maxLength: 200,
                      decoration: const InputDecoration(
                        hintText: "Enter message",
                      ),
                      onChanged: (value) {
                        _message = value;
                      },
                    ),
                  )),
                  IconButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection("posts")
                            .doc(post.id)
                            .collection("comments")
                            .add({
                              "userId": FirebaseAuth.instance.currentUser!.uid,
                              "userName": FirebaseAuth
                                  .instance.currentUser!.displayName,
                              "message": _message,
                              "timestamp": Timestamp.now(),
                            })
                            .then((value) => print("chat message add"))
                            .catchError((onError) => print("error message"));

                        _editingController.clear();

                        setState(() {
                          _message = "";
                        });
                      },
                      icon: const Icon(Icons.arrow_forward_rounded)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

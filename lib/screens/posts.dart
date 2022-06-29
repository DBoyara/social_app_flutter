import 'dart:io';

import 'package:app_09/bloc/auth_cubit.dart';
import 'package:app_09/screens/create_post.dart';
import 'package:app_09/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../models/post.dart';
import 'chat.dart';

class PostsScreen extends StatefulWidget {
  static const String id = "/posts";

  const PostsScreen({Key? key}) : super(key: key);

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                final picker = ImagePicker();
                picker
                    .pickImage(source: ImageSource.gallery, imageQuality: 40)
                    .then((xFile) {
                  if (xFile != null) {
                    final File file = File(xFile.path);
                    Navigator.of(context)
                        .pushNamed(CreatePostScreen.id, arguments: file);
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        duration: Duration(seconds: 2),
                        content: Text("choice image")),
                  );
                });
              },
              icon: const Icon(Icons.add)),
          IconButton(
              onPressed: () {
                context.read<AuthCubit>().signOut();
                // .then((_) =>
                // Navigator.of(context)
                //     .pushReplacementNamed(SignInScreen.id))
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("posts").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("Loading"));
          }
          return ListView.builder(
              itemCount: snapshot.data?.docs.length ?? 0,
              itemBuilder: (context, index) {

                if (snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No posts"));
                }

                final QueryDocumentSnapshot doc = snapshot.data!.docs[index];
                final Post post = Post(
                    imageURL: doc["imageURL"],
                    userId: doc["userId"],
                    userName: doc["userName"],
                    id: doc["postId"],
                    description: doc["description"],
                    time: doc["time"],
                );

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(ChatScreen.id, arguments: post);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(post.imageURL),
                              fit: BoxFit.cover,
                            )
                          ),
                        ),
                        const SizedBox(height: 5,),
                        Text(post.userName, style: Theme.of(context).textTheme.headline6,),
                        const SizedBox(height: 5,),
                        Text(post.description, style: Theme.of(context).textTheme.headline5,),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}

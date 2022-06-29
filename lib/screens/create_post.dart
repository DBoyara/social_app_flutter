import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreatePostScreen extends StatefulWidget {
  static const String id = "/create-post";

  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  String _description = "";

  Future<void> _submit({required File image}) async {
    FocusScope.of(context).unfocus();
    if (_description.trim().isNotEmpty) {
      late String imageURL = "";
      final FirebaseStorage storage = FirebaseStorage.instance;

      await storage
          .ref("images/${UniqueKey().toString()}.png")
          .putFile(image)
          .then((taskSnapshot) async {
        imageURL = await taskSnapshot.ref.getDownloadURL();
      });

      FirebaseFirestore.instance.collection("posts").add({
        "time": Timestamp.now(),
        "userId": FirebaseAuth.instance.currentUser!.uid,
        "description": _description,
        "userName": FirebaseAuth.instance.currentUser!.displayName,
        "imageURL": imageURL,
      }).then((docRef) => docRef.update({"postId": docRef.id}));
      // Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final File image = ModalRoute.of(context)!.settings.arguments as File;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create post"),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width / 1.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image:
                        DecorationImage(image: FileImage(image), fit: BoxFit.cover),
                  ),
                ),
                TextField(
                  decoration: const InputDecoration(
                    hintText: "Enter description",
                  ),
                  textInputAction: TextInputAction.done,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(128),
                  ],
                  onChanged: (value) {
                    _description = value;
                  },
                  onEditingComplete: () {
                    _submit(image: image);
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

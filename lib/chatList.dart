import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffeehouse/userRow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  ChatListState createState() => ChatListState();

  Widget getUsers(BuildContext context) {
    Stream<QuerySnapshot<Map<String, dynamic>>> users =
        FirebaseFirestore.instance.collection("Users").snapshots();

    Widget userList = StreamBuilder(
        stream: users,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return Align(
            alignment: Alignment.topCenter,
            child: ListView(
              // reverse: true,
              children: snapshot.data != null && snapshot.data!.docs.isNotEmpty
                  ? snapshot.data!.docs.map((user) {
                      if (user.id != FirebaseAuth.instance.currentUser!.uid) {
                        // return Text(user['name'] + " " + user['surname']);
                        return userRow(
                          id: user.id,
                          name: user['name'],
                          surname: user['surname'],
                          profilePicture: user['profileImageAddress'],
                        );
                      }
                      return Container();
                    }).toList()
                  : [const Center(child: CircularProgressIndicator())],
            ),
          );
        });

    return userList;
  }
}

class ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return widget.getUsers(context);
  }
}

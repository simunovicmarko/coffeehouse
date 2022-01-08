import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffeehouse/post.dart';
import 'package:flutter/material.dart';

class PostList extends StatelessWidget {
  const PostList({Key? key}) : super(key: key);

  Widget getPosts(BuildContext context) {
    Stream<QuerySnapshot<Map<String, dynamic>>> posts =
        FirebaseFirestore.instance.collection("Posts").snapshots();

    Widget postList = StreamBuilder(
        stream: posts,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return ListView(
            children: snapshot.data != null && snapshot.data!.docs.isNotEmpty
                ? snapshot.data!.docs.map((post) {
                    // return Text(post['userId'].toString());
                    return Post(
                      userId: post['userId'],
                      title: post['title'],
                      imageLink: post['imageLink'],
                      location: post['location'],
                      rating: post['rating'],
                    );
                  }).toList()
                : [const Text("skdljf")],
          );
        });

    return postList;
  }

  @override
  Widget build(BuildContext context) {
    return getPosts(context);
    // ListView(
    //   children: const [Post(), Post(), Post(), Post(), Post()],
    // );
  }
}

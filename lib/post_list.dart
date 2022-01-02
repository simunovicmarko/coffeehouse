import 'package:coffeehouse/post.dart';
import 'package:flutter/material.dart';

class PostList extends StatelessWidget {
  const PostList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [Post(), Post(), Post(), Post(), Post()],
      ),
    );
  }
}

import 'package:coffeehouse/addPost.dart';
// import 'package:coffeehouse/chat.dart';
import 'package:coffeehouse/chatList.dart';
import 'package:coffeehouse/post_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key, required this.setWidget}) : super(key: key);

  final void Function(Widget) setWidget;

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFCB745C),
      height: 70.0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                widget.setWidget(const PostList());
              },
              icon: SvgPicture.asset(
                'assets/House.svg',
                color: Colors.white,
              ),
              iconSize: 50,
            ),
            IconButton(
              onPressed: () {
                widget.setWidget(const AddPost());
              },
              icon: SvgPicture.asset(
                'assets/AddPicture.svg',
                color: Colors.white,
              ),
              iconSize: 50,
            ),
            IconButton(
              onPressed: () {
                widget.setWidget(const ChatList());
              },
              icon: SvgPicture.asset(
                'assets/PaperPlane.svg',
                color: Colors.white,
                width: 50.0,
                height: 50.0,
              ),
              iconSize: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

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
            SizedBox(
              child: SvgPicture.asset(
                'assets/House.svg',
                color: Colors.white,
              ),
              width: 50,
              height: 50,
            ),
            SizedBox(
              child: SvgPicture.asset(
                'assets/AddPicture.svg',
                color: Colors.white,
              ),
              width: 50,
              height: 50,
            ),
            SizedBox(
              child: SvgPicture.asset(
                'assets/PaperPlane.svg',
                color: Colors.white,
              ),
              width: 50,
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

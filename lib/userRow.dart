import 'package:coffeehouse/chat.dart';
import 'package:flutter/material.dart';

class UserRow extends StatelessWidget {
  const UserRow(
      {Key? key,
      this.id = "",
      this.name = "Jon",
      this.surname = "Doe",
      this.message = "Lorem ipsum",
      this.profilePicture =
          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"})
      : super(key: key);

  final String id;
  final String name;
  final String surname;
  final String message;
  final String profilePicture;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Chat(
                        recipientId: id,
                        name: "$name $surname",
                        photo: profilePicture,
                      )));
        },
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(const Color(0xFFAD6B55))),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: SizedBox(
                  width: 70,
                  height: 70,
                  child: Image(image: NetworkImage(profilePicture))),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: Text(
                "$name $surname",
                style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}

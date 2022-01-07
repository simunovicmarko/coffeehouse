import 'dart:io';

import 'package:coffeehouse/post.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:random_string/random_string.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  @override
  String imageLink =
      "https://erestaurantconsulting.ca/wp-content/uploads/2019/04/Restaurant-Performance-Measurement-1080x675.jpg";

  Future<bool> checkPermissions() async {
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    return permissionStatus.isGranted;
  }

  Future<void> uploadPhotoToFirebaseStorage(File file) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    TaskSnapshot snapshot =
        await storage.ref().child("posts/$randomAlpha(12)").putFile(file);

    String downloadUrl = await snapshot.ref.getDownloadURL();

    setState(() {
      imageLink = downloadUrl;
    });
  }

  Future<void> pickImage() async {
    ImagePicker _picker = ImagePicker();
    // File imageFile;
    if (await checkPermissions()) {
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        File file = File(image.path);
        uploadPhotoToFirebaseStorage(file);
      } else {
        print("null");
      }
    }
  }

  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      Center(
        child: IconButton(
            onPressed: () {
              pickImage();
            },
            icon: const Icon(
              Icons.photo_camera_back_rounded,
              color: Colors.white,
              size: 50,
            )),
      ),
      AspectRatio(
        // aspectRatio: 16 / 9,
        aspectRatio: 12 / 8,
        child: Container(
          // width: double.infinity,
          // height: 250,
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          decoration: BoxDecoration(
            image: DecorationImage(
              alignment: FractionalOffset.topCenter,
              image: NetworkImage(imageLink),
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
      const Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: InputField(
          hintText: "Add title",
        ),
      ),
      const Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: InputField(
          hintText: "Add description...",
        ),
      ),
      Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Row(children: [
          const SizedBox(
            width: 300,
            child: InputField(hintText: "Add location"),
          ),
          Container(
            alignment: Alignment.center,
            child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.add_location_rounded,
                  color: Colors.white,
                  size: 50,
                )),
          )
        ]),
      ),
      Beans(),
    ]));
  }
}

class InputField extends StatelessWidget {
  const InputField({Key? key, required this.hintText}) : super(key: key);

  final hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // controller: emailController,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        filled: true,
        contentPadding: const EdgeInsets.all(16),
        fillColor: const Color(0xFF865243),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}

class Beans extends StatelessWidget {
  const Beans({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Ratings(
        beanSize: 40,
        widtFactor: 1.0,
        isButton: true,
      ),
    );
  }
}

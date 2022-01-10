// ignore_for_file: file_names
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffeehouse/main.dart';
import 'package:coffeehouse/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:random_string/random_string.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key, this.userId}) : super(key: key);

  final String? userId;
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  String imageLink =
      "https://erestaurantconsulting.ca/wp-content/uploads/2019/04/Restaurant-Performance-Measurement-1080x675.jpg";

  File? newImageFile;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  int rating = 1;

  void addPostToFirebase() {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    if (titleController.text.isNotEmpty && imageLink.isNotEmpty) {
      Map<String, dynamic> postMap = {
        "userId": uid,
        "title": titleController.text,
        "description": descriptionController.text,
        "location": locationController.text,
        "rating": rating,
        "imageLink": imageLink,
        "createdAt": DateTime.now()
      };
      FirebaseFirestore.instance.collection('Posts').add(postMap).then(
          (value) => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MojApp())));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Izpolnite vsa zahtevana polja")));
  }

  Future<bool> checkPermissions() async {
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    return permissionStatus.isGranted;
  }

  Future<void> uploadPhotoToFirebaseStorage(File file) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    TaskSnapshot snapshot =
        await storage.ref().child("posts/" + randomAlpha(12)).putFile(file);

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
        setState(() {
          newImageFile = file;
        });
        uploadPhotoToFirebaseStorage(file);
      }
    }
  }

  ImageProvider<Object> decidePhoto() {
    if (newImageFile == null) {
      return NetworkImage(imageLink);
    }
    return FileImage(newImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {
                  pickImage();
                },
                icon: const Icon(
                  Icons.photo_camera_back_rounded,
                  color: Colors.white,
                  size: 50,
                )),
            IconButton(
                onPressed: () {
                  addPostToFirebase();
                },
                icon: const Icon(
                  // Icons.post_add,
                  Icons.upload,
                  color: Colors.white,
                  size: 50,
                )),
          ],
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
                // image: NetworkImage(imageLink),
                image: decidePhoto(),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child:
                InputField(hintText: "Add title", controller: titleController)),
        Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: InputField(
                hintText: "Add description...",
                controller: descriptionController)),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Row(children: [
            SizedBox(
                width: 300,
                child: InputField(
                    hintText: "Add location", controller: locationController)),
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
        Beans(
          rating: rating,
          setRating: (rating) {
            setState(() {
              this.rating = rating;
            });
          },
        ),
      ]),
    );
  }
}

class InputField extends StatelessWidget {
  const InputField({Key? key, required this.hintText, required this.controller})
      : super(key: key);

  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // controller: emailController,
      controller: controller,
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

class Beans extends StatefulWidget {
  const Beans({Key? key, this.setRating, this.rating = 3}) : super(key: key);

  final int rating;
  final Function(int)? setRating;

  @override
  State<Beans> createState() => _BeansState();
}

class _BeansState extends State<Beans> {
  // int rating = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Ratings(
          beanSize: 40,
          widtFactor: 1.0,
          isButton: true,
          rating: widget.rating,
          setRating: widget.setRating),
    );
  }
}

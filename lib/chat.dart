import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffeehouse/messageRow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class Chat extends StatefulWidget {
  const Chat(
      {Key? key,
      required this.recipientId,
      this.name = "Jon Doe",
      this.photo =
          "https://wompampsupport.azureedge.net/fetchimage?siteId=7575&v=2&jpgQuality=100&width=700&url=https%3A%2F%2Fi.kym-cdn.com%2Fentries%2Ficons%2Foriginal%2F000%2F032%2F558%2Ftemp6.jpg"})
      : super(key: key);

  final String recipientId;
  final String name;
  final String photo;

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  String recipientUUID = "qsIMPBjaV6PSU40Lm77izWlNgU72";
  String senderUUID = FirebaseAuth.instance.currentUser!.uid;
  String chatId = "aaa";

  String messageContent = "Lorem ipsum";

  final TextEditingController messageController = TextEditingController();

  List<Widget> getMessages(AsyncSnapshot<QuerySnapshot> snapshot) {
    var messages = snapshot.data != null && snapshot.data!.docs.isNotEmpty
        ? snapshot.data!.docs.map((message) {
            return Center(
                child: ListTile(
              title: message['SentBy'].toString() == senderUUID
                  ? SenderMessageRow(
                      key: Key(message.id), messageContent: message["Message"])
                  : RecipientMessageRow(
                      key: Key(message.id), messageContent: message["Message"]),
            ));
          }).toList()
        : [
            const Center(
                child: CircularProgressIndicator(
              color: Color(0xFFF839AF),
            ))
          ];

    return messages;
  }

  @override
  Widget build(BuildContext context) {
    recipientUUID = widget.recipientId;
    getDocumentIdWithBothUsersAsync();
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Coffehouse"),
              centerTitle: true,
              backgroundColor: const Color(0xFFB14D32),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 40,
                  )),
              actions: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: IconButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      },
                      icon: const Icon(
                        Icons.logout,
                        size: 40,
                      )),
                )
              ],
            ),
            body: Center(
              child: Stack(children: [
                Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 60),
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('Chat')
                            .doc(chatId)
                            .collection('Messages')
                            .orderBy('SentAt', descending: true)
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          return ListView(
                            reverse: true,
                            children: getMessages(snapshot),
                          );
                        })
                    // ],
                    // ),
                    ),
                Container(
                  color: const Color(0xFFAD6B55),
                  padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: SizedBox(
                            width: 70,
                            height: 70,
                            child: Image(image: NetworkImage(widget.photo))),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Text(
                          widget.name,
                          style: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    height: 50,
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                          hintText: "Type your message",
                          hintStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          contentPadding: const EdgeInsets.all(16),
                          fillColor: const Color(0xFF865243),
                          suffixIcon: IconButton(
                              // onPressed: sendMessage(messageController.text.trim()),
                              onPressed: () {
                                sendMessage(messageController.text.trim());
                              },
                              icon: const Icon(
                                Icons.send,
                                color: Colors.white,
                              ))),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ]),
            ),
            backgroundColor: const Color(0xFFDB8A74)));
  }

  Future<void Function()?> sendMessage(String message) async {
    if (message.isNotEmpty) {
      Map<String, dynamic> messageInfoMap = {
        "Message": message,
        "SentBy": senderUUID,
        "SentAt": DateTime.now(),
      };

      String docID = await getDocumentIdWithBothUsersAsync();
      await addMessage(docID, messageInfoMap);
    }
  }

  Future<void> addMessage(
      String docID, Map<String, dynamic> messageInfoMap) async {
    DocumentSnapshot<Object?> chat = await getChatById(
      docID,
    );

    if (!chat.exists) {
      DocumentReference temp =
          await FirebaseFirestore.instance.collection('Chat').add({
        "Members": [senderUUID, recipientUUID]
      });

      temp.collection('Messages').add(messageInfoMap);
    } else {
      FirebaseFirestore.instance
          .collection('Chat')
          .doc(docID)
          .collection('Messages')
          .add(messageInfoMap);
    }

    messageController.text = "";
  }

  Future<DocumentSnapshot<Object?>> getChatById(String docID) async {
    DocumentSnapshot chat =
        await FirebaseFirestore.instance.collection('Chat').doc(docID).get();
    return chat;
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getMessagesWithAutoId(
      BuildContext context) async {
    String id = await getDocumentIdWithBothUsersAsync();

    Stream<QuerySnapshot<Map<String, dynamic>>> messagesSnapshot =
        FirebaseFirestore.instance
            .collection('Chat')
            .doc(id)
            .collection('Messages')
            .snapshots();
    return messagesSnapshot;
  }

  Widget buildList(
      Stream<QuerySnapshot<Map<String, dynamic>>> messagesSnapshot) {
    return StreamBuilder(
        stream: messagesSnapshot,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return ListView(
            children: snapshot.data != null
                ? snapshot.data!.docs.map((message) {
                    return Center(
                        child: ListTile(
                      title: Text(message['SentAt']),
                    ));
                  }).toList()
                : [],
          );
        });
  }

  Future<String> getDocumentIdWithBothUsersAsync() async {
    QuerySnapshot<Map<String, dynamic>> chat = await FirebaseFirestore.instance
        .collection("Chat")
        .where('Members', arrayContainsAny: [senderUUID]).get();

    QuerySnapshot<Map<String, dynamic>> chat2 = await FirebaseFirestore.instance
        .collection("Chat")
        .where('Members', arrayContainsAny: [recipientUUID]).get();

    String docID = randomAlphaNumeric(12);
    for (var doc in chat.docs) {
      bool escape = false;
      for (var doc2 in chat2.docs) {
        if (doc.id == doc2.id) {
          docID = doc.id;
          escape = true;
          break;
        }
        if (escape) break;
      }
    }
    if (chatId != docID) {
      setState(() {
        chatId = docID;
      });
    }
    return docID;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffeehouse/messageRow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  String recipientUUID = "qsIMPBjaV6PSU40Lm77izWlNgU72";
  String senderUUID = FirebaseAuth.instance.currentUser!.uid;

  String messageContent =
      "Lorem ipsum neiofsbflsfgasfmčgfčgdsfničsfgdneiofsbflsfgasfmčgfčgdsfničsfgd";

  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 60),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Chat')
                  .doc("Pp3cNzZJ9TebUWrqGmkj")
                  .collection('Messages')
                  .orderBy('id', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                return ListView(
                  reverse: true,
                  children: snapshot.data != null &&
                          snapshot.data!.docs.isNotEmpty
                      ? snapshot.data!.docs.map((message) {
                          return Center(
                              child: ListTile(
                            title: message['SentBy'].toString() == senderUUID
                                ? SenderMessageRow(
                                    key: Key(message.id),
                                    messageContent: message["Message"])
                                : RecipientMessageRow(
                                    key: Key(message.id),
                                    messageContent: message["Message"]),
                          ));
                        }).toList()
                      : [const SenderMessageRow(messageContent: "Ne obstaja")],
                );
              })
          // ],
          // ),
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
    ]);
  }

  Future<void Function()?> sendMessage(String message) async {
    if (message.isNotEmpty) {
      Map<String, dynamic> messageInfoMap = {
        "Message": message,
        "SentBy": senderUUID,
        "SentAt": DateTime.now(),
      };

      String docID = await getDocumentIdWithBothUsers();
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
  }

  Future<DocumentSnapshot<Object?>> getChatById(String docID) async {
    DocumentSnapshot chat =
        await FirebaseFirestore.instance.collection('Chat').doc(docID).get();
    return chat;
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> temp(
      BuildContext context) async {
    String id = await getDocumentIdWithBothUsers();

    Stream<QuerySnapshot<Map<String, dynamic>>> messagesSnapshot =
        FirebaseFirestore.instance
            .collection('Chat')
            .doc(id)
            .collection('Messages')
            .snapshots();
    return messagesSnapshot;
    // return StreamBuilder(
    //     stream: messagesSnapshot,
    //     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //       return ListView(
    //         children: snapshot.data != null
    //             ? snapshot.data!.docs.map((message) {
    //                 return Center(
    //                     child: ListTile(
    //                   title: Text(message['SentAt']),
    //                 ));
    //               }).toList()
    //             : [],
    //       );
    //     });

    // Stream messages = await chatReference.collection('Messages').snapshots();

    // chatReference.snapshots();
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

  Future<String> getDocumentIdWithBothUsers() async {
    QuerySnapshot chat = await FirebaseFirestore.instance
        .collection("Chat")
        .where('Members', arrayContainsAny: [senderUUID]).get();

    QuerySnapshot chat2 = await FirebaseFirestore.instance
        .collection("Chat")
        .where('Members', arrayContainsAny: [recipientUUID]).get();

    String docID = randomAlphaNumeric(12);
    for (var doc in chat.docs) {
      for (var doc2 in chat2.docs) {
        if (doc.id == doc2.id) {
          docID = doc.id;
        }
      }
    }
    return docID;
  }
}

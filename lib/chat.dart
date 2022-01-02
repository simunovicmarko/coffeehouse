import 'package:coffeehouse/messageRow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  String recipientUUID = "qsIMPBjaV6PSU40Lm77izWlNgU72";
  String senderUUID = "qsIMPBjaV6PSU40Lm77izWlNgU72";

  String messageContent =
      "Lorem ipsum neiofsbflsfgasfmčgfčgdsfničsfgdneiofsbflsfgasfmčgfčgdsfničsfgd";

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          reverse: true,
          children: [
            SenderMessageRow(messageContent: messageContent),
            RecipientMessageRow(messageContent: messageContent),
            RecipientMessageRow(messageContent: messageContent),
            SenderMessageRow(messageContent: messageContent),
            SenderMessageRow(messageContent: messageContent),
            RecipientMessageRow(messageContent: messageContent),
            RecipientMessageRow(messageContent: messageContent),
            SenderMessageRow(messageContent: messageContent),
            SenderMessageRow(messageContent: messageContent),
            RecipientMessageRow(messageContent: messageContent),
            RecipientMessageRow(messageContent: messageContent),
            SenderMessageRow(messageContent: messageContent),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            alignment: Alignment.bottomCenter,
            height: 50,
            child: const TextField(
              decoration: InputDecoration(
                hintText: "Type your message",
                hintStyle: const TextStyle(color: Colors.white),
                filled: true,
                contentPadding: const EdgeInsets.all(16),
                fillColor: const Color(0xFF865243),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}

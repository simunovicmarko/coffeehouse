// ignore_for_file: file_names

import 'package:flutter/material.dart';

class SenderMessageRow extends StatelessWidget {
  const SenderMessageRow({
    Key? key,
    required this.messageContent,
  }) : super(key: key);

  final String messageContent;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: BoxConstraints(
              minWidth: 100, maxWidth: MediaQuery.of(context).size.width / 2),
          margin: const EdgeInsets.fromLTRB(0, 10, 10, 0),
          padding: const EdgeInsets.all(8.0),
          child: Text(
            messageContent,
            style: const TextStyle(fontSize: 16),
          ),
          color: const Color(0xFF69BFDB),
        ),
      ],
    );
  }
}

class RecipientMessageRow extends StatelessWidget {
  const RecipientMessageRow({
    Key? key,
    required this.messageContent,
  }) : super(key: key);

  final String messageContent;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: BoxConstraints(
              minWidth: 100, maxWidth: MediaQuery.of(context).size.width / 2),
          margin: const EdgeInsets.fromLTRB(10, 10, 0, 0),
          padding: const EdgeInsets.all(8.0),
          child: Text(
            messageContent,
            style: const TextStyle(fontSize: 16),
          ),
          color: const Color(0xFF7FDB8C),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../../domain/chat.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({
    super.key,
    required this.chat,
    required this.isMe,
  });

  final Chat chat;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 6,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isMe
                  ? Colors.orange.withOpacity(0.7)
                  : Theme.of(context).primaryColor.withOpacity(0.6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              chat.text,
              style: const TextStyle(
                fontSize: 18,
              ),
              overflow: TextOverflow.visible,
              softWrap: true,
            ),
          ),
        ),
      ],
    );
  }
}

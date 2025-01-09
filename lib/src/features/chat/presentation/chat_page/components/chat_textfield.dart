import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../chat_cubit.dart';

class ChatTextField extends StatefulWidget {
  const ChatTextField({
    super.key,
    required this.recieverId,
  });

  final String recieverId;

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Start typing...',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              String message = controller.text;
              controller.clear();
              if (message.isEmpty) return;
              context.read<ChatCubit>().sendChat(
                    recieverId: widget.recieverId,
                    message: message,
                  );
            },
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}

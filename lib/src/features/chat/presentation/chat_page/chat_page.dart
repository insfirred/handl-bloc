import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/domain/user_data.dart';
import '../../domain/chat.dart';
import 'chat_cubit.dart';
import 'components/chat_item.dart';
import 'components/chat_textfield.dart';

@RoutePage()
class ChatPage extends StatefulWidget {
  const ChatPage(
    this.reciever, {
    super.key,
  });

  final UserData reciever;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().fetchChats(widget.reciever.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              widget.reciever.name,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: context.read<ChatCubit>().fetchChats(widget.reciever.id),
        builder: (context, snapshot) {
          // Handle errors
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong!'),
            );
          }

          // Show loading indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Extract the chat data
          final chatList = snapshot.data;

          if (chatList == null || chatList.isEmpty) {
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: Text('Send "Hi" to ${widget.reciever.name}'),
                  ),
                ),
                ChatTextField(recieverId: widget.reciever.id),
              ],
            );
          }

          // When everything is all right!
          return ChatView(
            chats: snapshot.requireData,
            recieverId: widget.reciever.id,
          );
        },
      ),
    );
  }
}

class ChatView extends StatelessWidget {
  const ChatView({
    required this.chats,
    required this.recieverId,
    super.key,
  });

  final List<Chat> chats;
  final String recieverId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Chats
        Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: chats.length,
            itemBuilder: (context, index) {
              return ChatItem(
                chat: chats[index],
                isMe: chats[index].senderId != recieverId,
              );
            },
          ),
        ),

        // TextField with Send Btn
        ChatTextField(recieverId: recieverId),
      ],
    );
  }
}

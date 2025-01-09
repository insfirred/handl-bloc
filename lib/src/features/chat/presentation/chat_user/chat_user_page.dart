import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handl_bloc/src/features/chat/presentation/chat_user/chat_user_cubit.dart';
import 'package:handl_bloc/src/features/chat/presentation/chat_user/chat_user_state.dart';
import 'package:handl_bloc/src/routing/app_router.dart';

import '../../../auth/domain/user_data.dart';

@RoutePage()
class ChatUserPage extends StatefulWidget {
  const ChatUserPage({super.key});

  @override
  State<ChatUserPage> createState() => _ChatUserPageState();
}

class _ChatUserPageState extends State<ChatUserPage> {
  @override
  void initState() {
    super.initState();
    context.read<ChatUserCubit>().fetchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<ChatUserCubit, ChatUserState>(
          builder: (context, state) {
            if (state is ChatUsersLoaded) {
              return ChatView(state.users);
            }

            if (state is ChatUsersError) {
              return Center(child: Text(state.error));
            }

            return const Center(child: CircularProgressIndicator());
          },
          listener: (context, state) {
            if (state is ChatUsersError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
        ),
      ),
    );
  }
}

class ChatView extends StatelessWidget {
  const ChatView(this.users, {super.key});

  final List<UserData> users;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              'All Users',
              style: TextStyle(fontSize: 22),
            ),
          ),
          const SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: users.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(users[index].name),
                subtitle: Text(users[index].email),
                leading: const CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.person,
                  ),
                ),
                onTap: () {
                  context.navigateTo(
                    ChatRoute(reciever: users[index]),
                  );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

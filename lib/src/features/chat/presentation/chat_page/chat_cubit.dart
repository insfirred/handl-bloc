import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/chat_repo_impl.dart';
import '../../domain/chat.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(super.initialState);

  final chatRepo = ChatImpl();

  Stream<List<Chat>> fetchChats(String recieverId) {
    try {
      return chatRepo.fetchChats(recieverId);
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  Future<void> sendChat({
    required String recieverId,
    required String message,
  }) async {
    try {
      await chatRepo.sendChat(
        recieverId,
        message,
      );
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }
}

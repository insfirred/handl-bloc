import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/chat_repo_impl.dart';
import 'chat_user_state.dart';

class ChatUserCubit extends Cubit<ChatUserState> {
  ChatUserCubit(super.initialState);

  final chatRepo = ChatImpl();

  Future<void> fetchAllUsers() async {
    try {
      emit(ChatUsersLoading());
      var users = await chatRepo.fetchAllUsers();
      emit(ChatUsersLoaded(users));
    } catch (e) {
      log(e.toString());
      emit(ChatUsersError(e.toString()));
    }
  }
}

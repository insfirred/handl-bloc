import '../../../auth/domain/user_data.dart';

abstract class ChatUserState {}

class ChatUsersInitial extends ChatUserState {}

class ChatUsersLoading extends ChatUserState {}

class ChatUsersLoaded extends ChatUserState {
  final List<UserData> users;
  ChatUsersLoaded(this.users);
}

class ChatUsersError extends ChatUserState {
  final String error;
  ChatUsersError(this.error);
}

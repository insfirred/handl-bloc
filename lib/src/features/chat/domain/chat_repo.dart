import '../../auth/domain/user_data.dart';
import 'chat.dart';

abstract class ChatRepo {
  Future<List<UserData>> fetchAllUsers();

  Future<void> sendChat(String recieverId, String message);

  Stream<List<Chat>> fetchChats(String senderId);
}

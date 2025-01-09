import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../utils/app_utils.dart';
import '../../auth/domain/user_data.dart';
import '../domain/chat.dart';
import '../domain/chat_repo.dart';

class ChatImpl implements ChatRepo {
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  @override
  Future<List<UserData>> fetchAllUsers() async {
    List<UserData> users = [];
    try {
      var collectionSnapshot = await firestore.collection('users').get();

      for (var snapShot in collectionSnapshot.docs) {
        // skipping self user
        if (snapShot.id == auth.currentUser!.uid) continue;

        var userJson = snapShot.data();
        users.add(UserData.fromJson(userJson));
      }

      return users;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Stream<List<Chat>> fetchChats(String recieverId) {
    final currentUid = auth.currentUser!.uid;
    String chatId = AppUtils.newChatIdGenerator(currentUid, recieverId);

    try {
      return firestore
          .collection('chats')
          .doc('chatsDocs')
          .collection(chatId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return Chat.fromJson(doc.data());
        }).toList();
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> sendChat(String recieverId, String message) async {
    final currentUid = auth.currentUser!.uid;
    String chatId = AppUtils.newChatIdGenerator(currentUid, recieverId);
    DateTime now = DateTime.now();

    Chat chat = Chat(
      id: '',
      text: message,
      createdAt: now,
      senderId: recieverId,
    );

    try {
      await firestore
          .collection('chats')
          .doc('chatsDocs')
          .collection(chatId)
          .add(chat.toJson())
          .then(
            (value) => value.update({
              'id': value.id,
            }),
          );
    } catch (e) {
      throw Exception(e);
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/auth_repo.dart';
import '../domain/user_data.dart';

class AuthRepoImpl extends AuthRepo {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  @override
  Future<UserData?> getCurrentUser() async {
    User? authUser = auth.currentUser;

    if (authUser == null) return null;
    return UserData(
      id: authUser.uid,
      name: '',
      email: authUser.email!,
    );
  }

  @override
  Future<UserData?> login({
    required String email,
    required String password,
  }) async {
    try {
      var userCreds = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCreds.user != null) {
        var docSnapshot =
            await firestore.collection('users').doc(userCreds.user!.uid).get();

        if (docSnapshot.exists) {
          return UserData.fromJson(docSnapshot.data()!);
        } else {
          throw Exception('User Data not found. Contact developers');
        }
      }
      return null;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<UserData?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      var userCreds = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCreds.user != null) {
        var collectionRef = firestore.collection('users');

        UserData currentUser = UserData(
          id: userCreds.user!.uid,
          name: name,
          email: email,
        );

        await collectionRef.doc(userCreds.user!.uid).set(currentUser.toJson());
        return currentUser;
      }
      return null;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> logout() => auth.signOut();

  @override
  Future<String?> fetchUsernameById(String id) async {
    try {
      var docSnap = await firestore.collection('users').doc(id).get();
      if (docSnap.exists) {
        return docSnap.data()!['name'];
      }
    } catch (e) {
      throw Exception(e);
    }
    return null;
  }
}

import 'user_data.dart';

abstract class AuthRepo {
  Future<UserData?> getCurrentUser();

  Future<UserData?> login({
    required String email,
    required String password,
  });

  Future<UserData?> register({
    required String name,
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<String?> fetchUsernameById(String id);
}

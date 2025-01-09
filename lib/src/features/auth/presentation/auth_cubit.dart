import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/auth_repo.dart';
import '../domain/user_data.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.authRepo}) : super(AuthInitial());

  final AuthRepo authRepo;
  UserData? currentUser;

  void checkAuth() async {
    UserData? user = await authRepo.getCurrentUser();
    if (user != null) {
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  void login({
    required String email,
    required String password,
  }) async {
    try {
      log('email: $email');
      log('password: $password');

      emit(AuthLoading());
      UserData? user = await authRepo.login(
        email: email,
        password: password,
      );

      if (user != null) {
        currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(AuthError('Error while login. Please try again'));
        emit(Unauthenticated());
      }
    } catch (e) {
      log(e.toString());
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  void register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      log('name: $name');
      log('email: $email');
      log('password: $password');

      emit(AuthLoading());
      UserData? user = await authRepo.register(
        name: name,
        email: email,
        password: password,
      );

      if (user != null) {
        currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(AuthError('Error while Registering. Please try again'));
        emit(Unauthenticated());
      }
    } catch (e) {
      log(e.toString());
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  void logout() {
    authRepo.logout();
    emit(Unauthenticated());
  }

  Future<String?> fetchUsernameById(String id) =>
      authRepo.fetchUsernameById(id);
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/data/auth_repo_impl.dart';
import 'features/auth/domain/auth_repo.dart';
import 'features/auth/presentation/auth_cubit.dart';
import 'features/chat/presentation/chat_page/chat_cubit.dart';
import 'features/chat/presentation/chat_page/chat_state.dart';
import 'features/chat/presentation/chat_user/chat_user_cubit.dart';
import 'features/chat/presentation/chat_user/chat_user_state.dart';
import 'features/post/presentation/add_post_state.dart';
import 'features/post/presentation/post_cubit.dart';
import 'routing/app_router.dart';
import 'theme/app_theme.dart';

class HandlApp extends StatelessWidget {
  HandlApp({super.key});

  final AuthRepo authRepo = AuthRepoImpl();
  final AppRouter appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (BuildContext context) =>
              AuthCubit(authRepo: authRepo)..checkAuth(),
        ),
        BlocProvider<ChatUserCubit>(
          create: (BuildContext context) => ChatUserCubit(ChatUsersInitial()),
        ),
        BlocProvider<ChatCubit>(
          create: (BuildContext context) => ChatCubit(ChatInitial()),
        ),
        BlocProvider<PostCubit>(
          create: (BuildContext context) => PostCubit(AddPostInitial()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'HANDL',
        themeMode: ThemeMode.light,
        theme: GlobalThemData.lightThemeData,
        darkTheme: GlobalThemData.darkThemeData,
        routerDelegate: appRouter.delegate(),
        routeInformationParser: appRouter.defaultRouteParser(),
      ),
    );
  }
}

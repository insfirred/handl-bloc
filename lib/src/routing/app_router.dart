import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../features/auth/domain/user_data.dart';
import '../features/auth/presentation/auth_page.dart';
import '../features/chat/presentation/chat_page/chat_page.dart';
import '../features/chat/presentation/chat_user/chat_user_page.dart';
import '../features/home/presentation/components/comment_page.dart';
import '../features/main/presentation/main_page.dart';
import '../features/post/presentation/add_post_page.dart';
import '../features/profile/presentation/profile_page.dart';
import '../features/splash/presentation/splash_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          page: SplashRoute.page,
        ),
        AutoRoute(
          path: '/auth',
          page: AuthRoute.page,
        ),
        AutoRoute(
          path: '/main',
          page: MainRoute.page,
        ),
        CustomRoute(
          path: '/chat',
          page: ChatUserRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeft,
          durationInMilliseconds: 200,
        ),
        CustomRoute(
          path: '/chat',
          page: ChatRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeft,
          durationInMilliseconds: 100,
        ),
        CustomRoute(
          path: '/post',
          page: AddPostRoute.page,
          transitionsBuilder: TransitionsBuilders.slideBottom,
          durationInMilliseconds: 200,
        ),
        CustomRoute(
          path: '/comment',
          page: CommentRoute.page,
          transitionsBuilder: TransitionsBuilders.slideBottom,
          durationInMilliseconds: 200,
        ),
      ];
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../routing/app_router.dart';
import '../../auth/presentation/auth_cubit.dart';
import '../../auth/presentation/auth_state.dart';

@RoutePage()
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Text(
              'HANDL',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 50,
              ),
            ),
          ),
        );
      },
      listener: (context, state) async {
        await Future.delayed(const Duration(seconds: 2));
        if (state is Authenticated) {
          // Replace current route with MainRoute
          context.router.replace(const MainRoute());
        } else if (state is Unauthenticated) {
          // Replace current route with AuthRoute
          context.router.replace(const AuthRoute());
        } else if (state is AuthError) {
          // Show error message if authentication fails
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error while authenticating: ${state.error}'),
            ),
          );
        }
      },
    );
  }
}

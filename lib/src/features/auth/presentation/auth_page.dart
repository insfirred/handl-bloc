import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../routing/app_router.dart';
import 'auth_cubit.dart';
import 'auth_state.dart';
import 'components/login_section.dart';
import 'components/register_section.dart';

@RoutePage()
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLoginSection = true;

  toggleSection() {
    setState(() {
      isLoginSection = !isLoginSection;
      log('isLogin: $isLoginSection');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            context.replaceRoute(const MainRoute());
          }

          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error while authenticating')),
            );
          }
        },
        builder: (context, state) => SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: isLoginSection
              ? LoginSection(toggleSection)
              : RegisterSection(toggleSection),
        ),
      ),
    );
  }
}

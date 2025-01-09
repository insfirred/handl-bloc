import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth_cubit.dart';
import '../auth_state.dart';
import 'auth_text_field.dart';

class LoginSection extends StatefulWidget {
  const LoginSection(
    this.toggleSection, {
    super.key,
  });

  final void Function()? toggleSection;

  @override
  State<LoginSection> createState() => _LoginSectionState();
}

class _LoginSectionState extends State<LoginSection> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  _onLogin() {
    context.read<AuthCubit>().login(
          email: emailController.text,
          password: passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 100),

        // App Logo
        Center(
          child: Text(
            'H A N D L',
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 60),

        // Email Field
        const Text('Email'),
        const SizedBox(height: 10),
        AuthTextField(controller: emailController),
        const SizedBox(height: 30),

        // Password Field
        const Text('Password'),
        const SizedBox(height: 10),
        AuthTextField(controller: passwordController),
        const SizedBox(height: 15),

        // Section switch text
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text('Don\'t have an account?'),
            InkWell(
              onTap: widget.toggleSection,
              child: const Text(
                ' Register here',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 20)
          ],
        ),
        const SizedBox(height: 50),

        // Login Btn
        BlocConsumer<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: null,
                child: const CircularProgressIndicator(),
              );
            }

            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _onLogin,
              child: const Text('Login'),
            );
          },
          listener: (context, state) {},
        ),
      ],
    );
  }
}

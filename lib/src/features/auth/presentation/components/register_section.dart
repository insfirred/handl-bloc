import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth_cubit.dart';
import '../auth_state.dart';
import 'auth_text_field.dart';

class RegisterSection extends StatefulWidget {
  const RegisterSection(
    this.toggleSection, {
    super.key,
  });

  final void Function()? toggleSection;
  @override
  State<RegisterSection> createState() => _RegisterSectionState();
}

class _RegisterSectionState extends State<RegisterSection> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  _onRegister() {
    context.read<AuthCubit>().register(
          name: nameController.text,
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

        // Name Field
        const Text('Name'),
        const SizedBox(height: 10),
        AuthTextField(controller: nameController),
        const SizedBox(height: 30),

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

        // Confirm Password Field
        const Text('Confirm Password'),
        const SizedBox(height: 10),
        AuthTextField(controller: confirmPasswordController),
        const SizedBox(height: 15),

        // Section switch text
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text('Already have an account?'),
            InkWell(
              onTap: widget.toggleSection,
              child: const Text(
                ' Login here',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 20)
          ],
        ),
        const SizedBox(height: 50),

        // Register Btn
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
              onPressed: _onRegister,
              child: const Text('Register'),
            );
          },
          listener: (context, state) {},
        ),
      ],
    );
  }
}

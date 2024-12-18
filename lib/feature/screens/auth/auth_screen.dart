import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'auth_notifier.dart';
import 'blocs/auth_bloc.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Authentication')),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) async {
            if (state is AuthSuccess) {
              final authNotifier = context.read<AuthNotifier>();
              if (state.data.token != null) {
                // Проверка наличия роли, если роль не передается, используем значение по умолчанию
                final role = state.data.role ?? 'user';
                await authNotifier.login(state.data.token!, role);
                context.pushReplacement('/main');
              } else {
                throw Exception("AuthSuccess state returned null token");
              }
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },


          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (state is AuthInitial || state is AuthFailure) ...[
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final email = emailController.text.trim();
                        context.read<AuthBloc>().add(CheckUserExists(email));
                      },
                      child: const Text('Next'),
                    ),
                  ] else if (state is UserExistsState) ...[
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final email = emailController.text.trim();
                        final password = passwordController.text.trim();
                        context
                            .read<AuthBloc>()
                            .add(LoginPressed(email, password));
                      },
                      child: const Text('Login'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthReset());
                      },
                      child: const Text('GoBack'),
                    ),
                  ] else if (state is UserNotExistsState) ...[
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    TextField(
                      controller: confirmPasswordController,
                      decoration:
                          const InputDecoration(labelText: 'Confirm Password'),
                      obscureText: true,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final email = emailController.text.trim();
                        final password = passwordController.text.trim();
                        final confirmPassword =
                            confirmPasswordController.text.trim();
                        if (password == confirmPassword) {
                          context
                              .read<AuthBloc>()
                              .add(RegisterPressed(email, password));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Passwords do not match!')),
                          );
                        }
                      },
                      child: const Text('Register'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthReset());
                      },
                      child: const Text('GoBack'),
                    ),
                  ]
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

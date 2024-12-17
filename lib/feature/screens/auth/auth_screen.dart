import 'package:avto_afisha/feature/screens/event/widgets/event_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'blocs/auth_bloc.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoginMode = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> _saveUserData(String token, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('role', role);
  }

  void _toggleAuthMode() {
    setState(() {
      isLoginMode = !isLoginMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text(isLoginMode ? 'Login' : 'Register')),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) async {
            if (state is AuthSuccess) {
              await _saveUserData(state.data.token!, state.data.role!);
              context.pushReplacement('/main', extra: state.data.token);
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            if (state is AuthInitial || state is AuthFailure) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    if (!isLoginMode)
                      TextField(
                        controller: confirmPasswordController,
                        decoration: InputDecoration(labelText: 'Confirm Password'),
                        obscureText: true,
                      ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        final email = emailController.text;
                        final password = passwordController.text;

                        if (isLoginMode) {
                          context.read<AuthBloc>().add(LoginPressed(email, password));
                        } else {
                          final confirmPassword = confirmPasswordController.text;
                          if (password == confirmPassword) {
                            context.read<AuthBloc>().add(RegisterPressed(email, password));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Passwords do not match')),
                            );
                          }
                        }
                      },
                      child: Text(isLoginMode ? 'Login' : 'Register'),
                    ),
                    TextButton(
                      onPressed: _toggleAuthMode,
                      child: Text(
                        isLoginMode
                            ? 'Don\'t have an account? Register here'
                            : 'Already have an account? Login here',
                      ),
                    ),
                  ],
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

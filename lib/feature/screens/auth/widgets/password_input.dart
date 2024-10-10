import 'package:avto_afisha/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/auth_bloc.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final passwordController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            obscureText: true,
            controller: passwordController,
            decoration: InputDecoration(labelText: 'Password'),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              // Логика входа
              context.push('/home');
            },
            child: Text('Войти'),
          ),
          SizedBox(height: 8),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(ToggleLogin());
            },
            child: Text('Хочу войти под другим аккаунтом'),
          ),

        ],
      ),
    );
  }
}

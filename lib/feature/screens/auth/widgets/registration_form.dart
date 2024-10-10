import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth_bloc.dart';

class RegistrationFormWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final nameController = TextEditingController();
    final surnameController = TextEditingController();
    final passwordController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Имя'),
          ),
          TextField(
            controller: surnameController,
            decoration: InputDecoration(labelText: 'Фамилия'),
          ),
          TextField(
            obscureText: true,
            controller: passwordController,
            decoration: InputDecoration(labelText: 'Password'),
          ),
          SizedBox(height: 8),

          ElevatedButton(
            onPressed: () {
              // Логика регистрации
            },
            child: Text('Регистрация'),
          ),
          SizedBox(height: 8),

          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(ToggleLogin());
            },
            child: Text('Уже есть аккаунт'),
          ),

        ],
      ),
    );
  }
}

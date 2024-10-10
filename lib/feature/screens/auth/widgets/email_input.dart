import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_bloc.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              final email = emailController.text;
              context.read<AuthBloc>().add(ContinuePressed(email));
            },
            child: Text('Продолжить'),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(ToggleRegistration());
            },
            child: Text('Регистрация'),
          ),
        ],
      ),
    );
  }
}

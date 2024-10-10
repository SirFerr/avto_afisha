import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/auth_bloc.dart';
import 'widgets/email_input.dart';
import 'widgets/password_input.dart';
import 'widgets/registration_form.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text('Авторизация')),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthInitial || state is ToggleLogin) {
              return EmailInput();
            } else if (state is PasswordForm) {
              return PasswordInput();
            } else if (state is RegistrationForm) {
              return RegistrationFormWidget();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

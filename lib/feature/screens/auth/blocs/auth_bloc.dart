import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AuthEvent {}

class ContinuePressed extends AuthEvent {
  final String email;
  ContinuePressed(this.email);
}

class ToggleRegistration extends AuthEvent {}

abstract class AuthState {}

class AuthInitial extends AuthState {}

class ToggleLogin extends AuthEvent {}


class EmailSubmitted extends AuthState {}

class RegistrationForm extends AuthState {}

class PasswordForm extends AuthState {}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<ContinuePressed>((event, emit) {
      // Переход к форме ввода пароля или регистрации
      emit(PasswordForm());
      // if (isEmailValid(event.email)) {
      //   emit(PasswordForm());
      // } else {
      //   emit(RegistrationForm());
      // }
    });

    on<ToggleRegistration>((event, emit) {
      // Переключение между регистрацией и входом
      emit(RegistrationForm());
    });

    on<ToggleLogin>((event, emit) {
      emit(AuthInitial()); // Возвращаемся к начальному состоянию
    });
  }

  bool isEmailValid(String email) {
    // Простейшая проверка email
    return email.contains('@');
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../constans/constants.dart';
import '../../../../../models/req_res_model.dart';
import '../../../../../models/user_model.dart';

// Authentication Events
abstract class AuthEvent {}

class LoginPressed extends AuthEvent {
  final String email;
  final String password;

  LoginPressed(this.email, this.password);
}

class LogoutPressed extends AuthEvent {}

// Authentication States
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;

  AuthSuccess(this.user);
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure(this.error);
}

// Authentication Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginPressed>(_onLoginPressed);
    on<LogoutPressed>(_onLogoutPressed);
  }

  Future<void> _onLoginPressed(LoginPressed event, Emitter<AuthState> emit) async {
    emit(AuthInitial());
    try {
      final response = await http.post(
        Uri.parse('$API/auth/signin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': event.email, 'password': event.password}),
      );

      if (response.statusCode == 200) {
        final data = ReqRes.fromJson(jsonDecode(response.body));
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('token', data.token!);
        await prefs.setString('refreshToken', data.refreshToken!);

        emit(AuthSuccess(User(
          id: 0, // Backend должен возвращать ID пользователя
          email: data.email!,
          role: data.role!,
        )));
      } else {
        final errorData = jsonDecode(response.body);
        emit(AuthFailure(errorData['error'] ?? 'Invalid credentials'));
      }
    } catch (e) {
      emit(AuthFailure("Error: $e"));
    }
  }

  Future<void> _onLogoutPressed(LogoutPressed event, Emitter<AuthState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('refreshToken');
    emit(AuthInitial());
  }
}
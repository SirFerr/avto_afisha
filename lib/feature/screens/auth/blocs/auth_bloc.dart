import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../constans/constants.dart';
import '../../../../../models/req_res_model.dart';

// Authentication Events
abstract class AuthEvent {}

class LoginPressed extends AuthEvent {
  final String email;
  final String password;

  LoginPressed(this.email, this.password);
}

class RegisterPressed extends AuthEvent {
  final String email;
  final String password;

  RegisterPressed(this.email, this.password);
}

class RefreshTokenPressed extends AuthEvent {}

class LogoutPressed extends AuthEvent {}

// Authentication States
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthSuccess extends AuthState {
  final ReqRes data;

  AuthSuccess(this.data);
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure(this.error);
}

class AuthLoading extends AuthState {}

// Authentication Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginPressed>(_onLoginPressed);
    on<RegisterPressed>(_onRegisterPressed);
    on<RefreshTokenPressed>(_onRefreshTokenPressed);
    on<LogoutPressed>(_onLogoutPressed);
  }

  Future<void> _onLoginPressed(LoginPressed event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
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
        await prefs.setString('role', data.role!);

        emit(AuthSuccess(data));
      } else {
        emit(AuthFailure('Login failed: ${response.body}'));
      }
    } catch (e) {
      emit(AuthFailure('Error: $e'));
    }
  }

  Future<void> _onRegisterPressed(RegisterPressed event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await http.post(
        Uri.parse('$API/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': event.email, 'password': event.password}),
      );

      if (response.statusCode == 200) {
        final data = ReqRes.fromJson(jsonDecode(response.body));
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('token', data.token!);
        await prefs.setString('refreshToken', data.refreshToken!);
        await prefs.setString('role', data.role!);

        emit(AuthSuccess(data));
      } else {
        emit(AuthFailure('Registration failed: ${response.body}'));
      }
    } catch (e) {
      emit(AuthFailure('Error: $e'));
    }
  }

  Future<void> _onRefreshTokenPressed(RefreshTokenPressed event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refreshToken');

      final response = await http.post(
        Uri.parse('$API/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = ReqRes.fromJson(jsonDecode(response.body));
        await prefs.setString('token', data.token!);
        await prefs.setString('refreshToken', data.refreshToken!);

        emit(AuthSuccess(data));
      } else {
        emit(AuthFailure('Token refresh failed: ${response.body}'));
      }
    } catch (e) {
      emit(AuthFailure('Error: $e'));
    }
  }

  Future<void> _onLogoutPressed(LogoutPressed event, Emitter<AuthState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('refreshToken');
    await prefs.remove('role');
    emit(AuthInitial());
  }
}

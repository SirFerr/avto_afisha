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

class CheckUserExists extends AuthEvent {
  final String email;

  CheckUserExists(this.email);
}

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

class UserExistsState extends AuthState {}

class UserNotExistsState extends AuthState {}
class AuthReset extends AuthEvent {}


// Authentication Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginPressed>(_onLoginPressed);
    on<RegisterPressed>(_onRegisterPressed);
    on<CheckUserExists>(_onCheckUserExists);
    on<AuthReset>((event, emit) => emit(AuthInitial()));

  }

  Future<void> _onLoginPressed(LoginPressed event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await http.post(
        Uri.parse('$API2/auth/signin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': event.email, 'password': event.password}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final data = ReqRes(
          statusCode: responseData['statusCode'],
          token: responseData['token'],
          refreshToken: responseData['refreshToken'],
          expirationTime: responseData['expirationTime'],
        );

        if (data.token != null) {
          emit(AuthSuccess(data));
        } else {
          emit(AuthFailure('Login failed: Missing token in response'));
        }
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
        Uri.parse('$API2/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': event.email, 'password': event.password, 'role': 'user'}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final data = ReqRes(
          statusCode: responseData['statusCode'],
          token: responseData['token'],
          refreshToken: responseData['refreshToken'],
          expirationTime: responseData['expirationTime'],
        );

        if (data.token != null) {
          emit(AuthSuccess(data));
        } else {
          emit(AuthFailure('Registration failed: Missing token in response'));
        }
      } else {
        emit(AuthFailure('Registration failed: ${response.body}'));
      }
    } catch (e) {
      emit(AuthFailure('Error: $e'));
    }
  }

  Future<void> _onCheckUserExists(CheckUserExists event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await http.get(
        Uri.parse('$API2/user/find-user/${event.email}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final userExists = jsonDecode(response.body) as bool;
        if (userExists) {
          emit(UserExistsState());
        } else {
          emit(UserNotExistsState());
        }
      } else {
        emit(AuthFailure('Error checking user existence: ${response.body}'));
      }
    } catch (e) {
      emit(AuthFailure('Error: $e'));
    }
  }
}
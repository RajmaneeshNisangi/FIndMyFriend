import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }
  void _onAuthLoginRequested(
      AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final email = event.email;
      final password = event.password;
      if (email.trim().isEmpty || !email.contains('@')) {
        return emit(AuthFailure('Please enter a valid email address.'));
      }
      if (password.length < 8) {
        return emit(
            AuthFailure('The password must contain atleast 8 characters'));
      }
      await Future.delayed(const Duration(seconds: 01), () {
        return emit(AuthSuccess(uid: 'Hello $email'));
      });
    } catch (e) {
      return emit(AuthFailure(e.toString()));
    }
  }
}

void _onAuthLogoutRequested(
    AuthLogoutRequested event, Emitter<AuthState> emit) async {
  emit(AuthLoading());
  try {
    await Future.delayed(const Duration(seconds: 1), () {
      return emit(AuthInitial());
    });
  } catch (e) {
    emit(AuthFailure(e.toString()));
  }
}

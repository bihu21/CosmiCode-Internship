import 'package:equatable/equatable.dart';
import 'package:chat_app_flutter/data/models/user_model.dart'; // Make sure this path is correct

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState extends Equatable {
  final AuthStatus status;
  final UserModel? user;
  final String error;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.error = '',
  });

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, user, error];
}

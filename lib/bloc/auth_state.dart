part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInit extends AuthState {
  const AuthInit();

  @override
  List<Object> get props => [];
}

class AuthLoading extends AuthState {
  const AuthLoading();

  @override
  List<Object> get props => [];
}

class AuthSignUp extends AuthState {
  const AuthSignUp();

  @override
  List<Object> get props => [];
}

class AuthSignIn extends AuthState {
  const AuthSignIn();

  @override
  List<Object> get props => [];
}

class AuthError extends AuthState {
  final String message;
  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
}
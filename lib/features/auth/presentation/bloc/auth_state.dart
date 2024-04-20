part of 'auth_bloc.dart';

@immutable
sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}


final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final String success;
   const AuthSuccess(this.success);
}
final class AuthSuccess2 extends AuthState {
  final UserDataModel user;
  const AuthSuccess2(this.user);
}

final class AuthFailure extends AuthState {
  final String message;
  const  AuthFailure(this.message);
}
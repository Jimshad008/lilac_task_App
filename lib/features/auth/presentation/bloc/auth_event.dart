part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}
final class AuthLogin extends AuthEvent {
  final String phoneNo;
  final BuildContext context;

  AuthLogin({
    required this.phoneNo,
    required this.context,
  });
}
final class AuthOtpVerify extends AuthEvent{
  final String verificationId;
  final String otp;
  AuthOtpVerify({
    required this.otp,required this.verificationId
});
}
final class AuthAddUser extends AuthEvent{
  final String name;
  final String email;
  final String authId;
  final String phoneNo;
  final File image;
  final String dob;
  AuthAddUser({required this.image,
    required this.authId,required this.phoneNo,required this.name,required this.email,required this.dob
  });
}
final class AuthGetUser extends AuthEvent{
  final String authId;

  AuthGetUser({
    required this.authId
  });
}
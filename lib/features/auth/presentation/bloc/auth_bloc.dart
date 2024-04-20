import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:lilac_task/features/auth/data/model/user_data_model.dart';
import 'package:meta/meta.dart';


import '../../domain/usecases/addUser.dart';
import '../../domain/usecases/getUser.dart';
import '../../domain/usecases/otp_verify.dart';
import '../../domain/usecases/user_login.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserLogin _userLogin;
  final OtpVerify _otpVerify;
  final GetUser _getUser;
  final AddUser _addUser;

  AuthBloc({required UserLogin userLogin,required OtpVerify otpVerify,required GetUser getUser,required AddUser addUser}) : _userLogin=userLogin,_otpVerify=otpVerify,_getUser=getUser,_addUser=addUser,super(AuthInitial()) {
    on<AuthLogin>((event, emit) async {
      emit(AuthLoading());
final res=await _userLogin.authRepository.loginWithPhoneNo(phoneNo: event.phoneNo,context: event.context);
res.fold(
      (l) => emit(AuthFailure( l.message)),
      (uid) => emit(AuthSuccess( uid)),
);
    });
    on<AuthOtpVerify>((event,emit)async{
      emit(AuthLoading());
      final res=await _otpVerify.authRepository.otpVerify(verificationId: event.verificationId, otp: event.otp);
      res.fold(
            (l) => emit(AuthFailure( l.message)),
            (uid) => emit(AuthSuccess( uid)),
      );
       });
    on<AuthAddUser>((event,emit)async{
      emit(AuthLoading());
      final res=await _addUser.authRepository.addUser(name: event.name, dob: event.dob, image: event.image, phoneNo: event.phoneNo, authId: event.authId, email: event.email);
      res.fold(
            (l) => emit(AuthFailure( l.message)),
            (uid) => emit(AuthSuccess2( uid)),
      );
    });
    on<AuthGetUser>((event,emit)async{
      emit(AuthLoading());
      final res=await _getUser.authRepository.getUser(authId: event.authId);
      res.fold(
            (l) => emit(AuthFailure( l.message)),
            (uid) => emit(AuthSuccess2( uid)),
      );
    });
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lilac_task/features/auth/data/model/user_data_model.dart';

import '../../../../core/error/Failure.dart';
import '../entities/user_data.dart';



abstract interface class AuthRepository {


  Future<Either<Failure, String>> loginWithPhoneNo(
      {required String phoneNo,required BuildContext context});
  Future<Either<Failure, String>> otpVerify(
      {required String verificationId,required String otp});
  Future<Either<Failure, UserDataModel>> addUser({
    required String name,
    required String dob,
    required File image,
    required String phoneNo,
    required String authId,
    required String email,
  });
  Future<Either<Failure, UserDataModel>> getUser({
    required String authId
});
}
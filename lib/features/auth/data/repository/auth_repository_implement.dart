

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/Failure.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/utils/set_search.dart';
import '../../domain/repository/auth_repository.dart';
import '../dataSource/auth_remote_data_source.dart';
import '../model/user_data_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  const AuthRepositoryImpl(this.authRemoteDataSource);

  @override
  Future<Either<Failure, String>> loginWithPhoneNo({required String phoneNo,required BuildContext context}) async {
    try {
      final userId = await authRemoteDataSource.loginWithPhoneNo(context: context,
          phoneNo: phoneNo);

      return right(userId);
    } on ServerException catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> otpVerify({required String verificationId, required String otp}) async {
    try {
      final userId = await authRemoteDataSource.verifyOtp(
          verificationId: verificationId, otp: otp);
      return right(userId);
    }on ServerException catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserDataModel>> addUser({required String name, required String dob, required File image, required String phoneNo, required String authId,required String email}) async {
    try{
      final imageUrl=await authRemoteDataSource.uploadImage(image: image);
      final user=UserDataModel(dob: dob,authId: authId, name: name, imageUrl: imageUrl, phoneNo: phoneNo,search: setSearchParam(name.toUpperCase()) + setSearchParam(phoneNo.toUpperCase()), email: email);
      await authRemoteDataSource.addUser(user);
      return right(user);

    } on ServerException catch (e) {
      return left(Failure( message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserDataModel>> getUser({required String authId}) async{
    try {
      final user =await authRemoteDataSource.getUser(authId: authId);
      return right(user);
    }on ServerException catch (e) {
      return left(Failure( message: e.message));
    }
  }


}
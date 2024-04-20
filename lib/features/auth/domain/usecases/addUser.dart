import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:lilac_task/features/auth/domain/repository/auth_repository.dart';

import '../../../../core/error/Failure.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/user_data.dart';

class AddUser implements UseCase<UserData,UserParam>{
  final AuthRepository authRepository;
  AddUser(this.authRepository);

  @override
  Future<Either<Failure, UserData>> call(UserParam params) async{
    return await authRepository.addUser(name: params.name, dob: params.dob, image: params.image,phoneNo: params.phoneNo, authId: params.authId,email: params.email);
  }
}
class UserParam{
  final String name;
  final String dob;
  final File image;
  final String authId;
  final String phoneNo;
  final String email;
  UserParam({required this.authId,required this.dob,
    required this.name,required this.image,required this.phoneNo,required this.email
  });
}
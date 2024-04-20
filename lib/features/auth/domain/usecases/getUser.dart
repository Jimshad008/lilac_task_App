
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/Failure.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/user_data.dart';
import '../repository/auth_repository.dart';

class GetUser implements UseCase<UserData,String>{
  final AuthRepository authRepository;
  GetUser(this.authRepository);

  @override
  Future<Either<Failure, UserData>> call(String params) async{
    return await authRepository.getUser(authId: params);
  }
}
import 'package:fpdart/src/either.dart';

import 'package:lilac_task/core/error/Failure.dart';
import 'package:lilac_task/features/home/domain/repository/home_repository.dart';

import '../../../../core/usecases/usecases.dart';
import '../../../auth/domain/entities/user_data.dart';

class FetchVideo implements UseCase<Map<String,List>,String>{
  final HomeRepository homeRepository;
  FetchVideo(this.homeRepository);
  @override
  Future<Either<Failure, Map<String,List>>> call(String params) async {
    return await homeRepository.fetchVideo();
  }

}
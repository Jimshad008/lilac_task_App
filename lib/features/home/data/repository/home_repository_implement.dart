import 'package:fpdart/src/either.dart';

import 'package:lilac_task/core/error/Failure.dart';

import '../../../../core/error/exception.dart';
import '../../domain/repository/home_repository.dart';
import '../dataSource/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource homeRemoteDataSource;
  const HomeRepositoryImpl(this.homeRemoteDataSource);
  @override
  Future<Either<Failure, Map<String, List>>> fetchVideo() async {
    try {
      final res = await homeRemoteDataSource.fetchVideo();

      return right(res);
    } on ServerException catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

}
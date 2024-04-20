import 'package:fpdart/fpdart.dart';

import '../../../../core/error/Failure.dart';

abstract interface class HomeRepository {
  Future<Either<Failure, Map<String, List>>>fetchVideo();
}
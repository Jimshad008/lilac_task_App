import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

import 'features/auth/data/dataSource/auth_remote_data_source.dart';
import 'features/auth/data/repository/auth_repository_implement.dart';
import 'features/auth/domain/repository/auth_repository.dart';
import 'features/auth/domain/usecases/otp_verify.dart';
import 'features/auth/domain/usecases/user_login.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();

  final firebaseAuth = FirebaseAuth.instance;
  final firestore=FirebaseFirestore.instance;
  final firebaseStorage=FirebaseStorage.instance;

  serviceLocator.registerLazySingleton(() => firebaseAuth);
  serviceLocator.registerLazySingleton(() => firestore);
  serviceLocator.registerLazySingleton(() => firebaseStorage);
}
_initAuth(){
  serviceLocator.registerFactory<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory<AuthRepository>(
        () => AuthRepositoryImpl(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
        () => OtpVerify(
      serviceLocator(),
    ),

  );

  serviceLocator.registerFactory(
        () => UserLogin(
      serviceLocator(),
    ),

  );
  serviceLocator.registerLazySingleton(
        () => AuthBloc(userLogin: serviceLocator(), otpVerify: serviceLocator(),
    ),
  );
}

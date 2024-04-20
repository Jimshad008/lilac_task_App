import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:lilac_task/core/constant/theme_bool/bloc/theme_bool_bloc.dart';
import 'package:lilac_task/core/constant/video_index/bloc/video_index_bloc.dart';
import 'package:lilac_task/features/auth/domain/usecases/addUser.dart';
import 'package:lilac_task/features/auth/domain/usecases/getUser.dart';
import 'package:lilac_task/features/home/domain/usecase/fetch_video.dart';
import 'package:lilac_task/features/home/presentation/bloc/home_bloc.dart';

import 'features/auth/data/dataSource/auth_remote_data_source.dart';
import 'features/auth/data/repository/auth_repository_implement.dart';
import 'features/auth/domain/repository/auth_repository.dart';
import 'features/auth/domain/usecases/otp_verify.dart';
import 'features/auth/domain/usecases/user_login.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/home/data/dataSource/home_remote_data_source.dart';
import 'features/home/data/repository/home_repository_implement.dart';
import 'features/home/domain/repository/home_repository.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _themeBool();
  _initHome();
  _changeIndex();

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
      serviceLocator(),serviceLocator(),serviceLocator()
    ),
  );
  serviceLocator.registerFactory<AuthRepository>(
        () => AuthRepositoryImpl(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
        () => AddUser(
      serviceLocator(),
    ),

  );
  serviceLocator.registerFactory(
        () => GetUser(
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
        () => AuthBloc(userLogin: serviceLocator(), otpVerify: serviceLocator(), getUser: serviceLocator(), addUser: serviceLocator(),
    ),
  );
}
_themeBool(){
  serviceLocator.registerLazySingleton(
        () => ThemeBoolBloc(),

  );
}
_initHome(){
  serviceLocator.registerFactory<HomeRemoteDataSource>(
        () => HomeRemoteDataSourceImpl(
    ),
  );
  serviceLocator.registerFactory<HomeRepository>(
        () => HomeRepositoryImpl(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
        () => FetchVideo(
      serviceLocator(),
    ),

  );
  serviceLocator.registerLazySingleton(
        () => HomeBloc( fetchVideo: serviceLocator(),
    ),
  );
}
_changeIndex(){
  serviceLocator.registerLazySingleton(
        () => VideoIndexBloc(),

  );
}

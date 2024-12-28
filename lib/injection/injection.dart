import 'package:esvilla_app/data/repositories/auth_repository_impl.dart';
import 'package:esvilla_app/data/repositories/user_repository_impl.dart';
import 'package:esvilla_app/domain/repositories/auth_repository.dart';
import 'package:esvilla_app/domain/repositories/user_repository.dart';
import 'package:esvilla_app/domain/use_cases/get_users_use_case.dart';
import 'package:esvilla_app/domain/use_cases/login_use_case.dart';
import 'package:esvilla_app/presentation/controller/auth_controller.dart';
import 'package:esvilla_app/presentation/controller/user_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../data/datasources/auth/auth_local_data_source.dart';
import '../data/datasources/auth/auth_remote_data_source.dart';
import '../data/datasources/user/auth_mock_data_source.dart';

final sl = GetIt.instance;

void init() {
  sl.registerLazySingleton(() => UserMockDataSource());
  sl.registerLazySingleton(() => AuthMockDataSource());
  sl.registerLazySingleton(() => AuthRemoteDataSource(sl()));
  // Controllers
  sl.registerFactory(() => UserController(sl()));
  sl.registerFactory(() => AuthController(sl()));
  // Use cases
  sl.registerLazySingleton(() => GetUsersUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  // Repositories
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  // Data sources
  // serviceLocator.registerLazySingleton(() => User)
  // Http client
  sl.registerLazySingleton(() => http.Client()); 
  
}
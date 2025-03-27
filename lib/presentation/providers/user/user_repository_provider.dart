import 'package:esvilla_app/core/config/dio_config.dart';
import 'package:esvilla_app/data/datasources/users/users_remote_data_source.dart';
import 'package:esvilla_app/data/repositories/user_repository_impl.dart';
import 'package:esvilla_app/domain/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProvider = Provider<UserRepository>(
  (ref) {
    final dio = ref.watch(dioClientProvider).dio;
    return UserRemoteRepositoryImpl(
      UsersRemoteDataSource(dio),
    );
  }
);
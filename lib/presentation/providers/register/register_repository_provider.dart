import 'package:esvilla_app/core/config/dio_config.dart';
import 'package:esvilla_app/data/datasources/auth/auth_remote_data_source.dart';
import 'package:esvilla_app/data/repositories/register_repository_impl.dart';
import 'package:esvilla_app/domain/repositories/register_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final registerRepositoryProvider = Provider<RegisterRepository>((ref){
  return RegisterRepositoryImpl(AuthRemoteDataSource(ref.watch(dioClientProvider).dio));
});
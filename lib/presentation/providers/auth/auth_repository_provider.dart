import 'package:esvilla_app/core/config/dio_config.dart';
import 'package:esvilla_app/data/datasources/auth/auth_remote_data_source.dart';
import 'package:esvilla_app/data/repositories/auth/auth_repository_impl.dart';
import 'package:esvilla_app/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref){
  return AuthRemoteRepositoryImpl(AuthRemoteDataSource(ref.watch(dioClientProvider).dio));
 /*  final hasInternet = ref.watch(connectivityProvider).isConnected;
    if (hasInternet) {
      return AuthRemoteRepositoryImpl(AuthRemoteDataSource(http.Client()));
    }else{
      return AuthLocalRepositoryImpl(AuthLocalDataSource());
    } */
});
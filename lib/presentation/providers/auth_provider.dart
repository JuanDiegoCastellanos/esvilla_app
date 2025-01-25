import 'package:esvilla_app/data/datasources/auth/auth_local_data_source.dart';
import 'package:esvilla_app/data/datasources/auth/auth_remote_data_source.dart';
import 'package:esvilla_app/data/repositories/auth_repository_impl.dart';
import 'package:esvilla_app/domain/repositories/auth_repository.dart';
import 'package:esvilla_app/presentation/providers/conectivity_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final authRepositoryProvider = Provider<AuthRepository>((ref){
  final hasInternet = ref.watch(connectivityProvider).isConnected;
    if (hasInternet) {
      return AuthRemoteRepositoryImpl(AuthRemoteDataSource(http.Client()));
    }else{
      return AuthLocalRepositoryImpl(AuthLocalDataSource());
    }
});
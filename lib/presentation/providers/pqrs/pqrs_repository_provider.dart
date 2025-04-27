import 'package:esvilla_app/core/config/dio_config.dart';
import 'package:esvilla_app/data/datasources/pqrs/pqrs_remote_data_source.dart';
import 'package:esvilla_app/data/repositories/pqrs/pqrs_repository_impl.dart';
import 'package:esvilla_app/domain/repositories/pqrs_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pqrsRepositoryProvider = Provider<PqrsRepository>((ref) {
  final dio = ref.watch(dioClientProvider).dio;
  return PqrsRepositoryImpl(
    PqrsRemoteDataSource(dio),
  );
});


import 'package:esvilla_app/core/config/dio_config.dart';
import 'package:esvilla_app/data/datasources/schedules/schedules_remote_data_source.dart';
import 'package:esvilla_app/data/repositories/schedules/schedules_repository_impl.dart';
import 'package:esvilla_app/domain/repositories/schedules_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final schedulesRepositoryProvider = Provider<SchedulesRepository>((ref) {
  final dio = ref.watch(dioClientProvider).dio;
  return SchedulesRepositoryImpl(SchedulesRemoteDataSource(dio));
});
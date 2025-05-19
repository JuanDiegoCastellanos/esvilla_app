import 'package:esvilla_app/core/config/dio_config.dart';
import 'package:esvilla_app/data/datasources/sectors/sectors_remote_data_source.dart';
import 'package:esvilla_app/data/repositories/sectors/sector_repository_impl.dart';
import 'package:esvilla_app/domain/repositories/sectors_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sectorRepositoryProvider = Provider<SectorsRepository>((ref) {
  final dio = ref.watch(dioClientProvider).dio;
  final repo = SectorRepositoryImpl(SectorsRemoteDataSource(dio));
  return repo;
});
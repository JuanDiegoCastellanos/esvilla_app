import 'package:esvilla_app/core/config/dio_config.dart';
import 'package:esvilla_app/data/datasources/announcements/announcements_remote_data_source.dart';
import 'package:esvilla_app/data/repositories/announcements/announcements_repository_impl.dart';
import 'package:esvilla_app/domain/repositories/announcements_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final announcementRepositoryProvider = Provider<AnnouncementsRepository>((ref) {
  final dioInstance = ref.watch(dioClientProvider);
  final repository = AnnouncementsRepositoryImpl(AnnouncementsRemoteDataSource(dioInstance.dio));
  return repository;
});
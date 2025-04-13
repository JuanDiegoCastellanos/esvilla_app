import 'package:esvilla_app/domain/use_cases/user/get_user_by_id_use_case.dart';
import 'package:esvilla_app/presentation/providers/user/user_model_presentation.dart';
import 'package:esvilla_app/presentation/providers/user/user_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getUserByIdProvider = FutureProvider.family<UserPresentationModel, String>((ref, id) async {
  final repository = ref.watch(userRepositoryProvider);
  final useCase = GetUserByIdUseCase(repository);
  if (id.isEmpty) return UserPresentationModel.empty();
  final entity = await useCase(id);
  return UserPresentationModel.fromEntity(entity);
});
import 'package:esvilla_app/domain/use_cases/user/update_my_profile_use_case.dart';
import 'package:esvilla_app/presentation/providers/user/user_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updateMyProfileUseCaseProvider = Provider<UpdateMyProfileUseCase>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return UpdateMyProfileUseCase(repo);
});
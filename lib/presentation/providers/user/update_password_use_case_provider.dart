import 'package:esvilla_app/domain/use_cases/user/update_password_use_case.dart';
import 'package:esvilla_app/presentation/providers/user/user_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updatePasswordUseCaseProvider = Provider<UpdatePasswordUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return UpdatePasswordUseCase(repository);
});

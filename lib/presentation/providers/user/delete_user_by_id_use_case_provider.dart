import 'package:esvilla_app/domain/use_cases/user/delete_user_use_case.dart';
import 'package:esvilla_app/presentation/providers/user/user_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deleteUserByIdUseCaseProvider = Provider<DeleteUserUseCase>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return DeleteUserUseCase(userRepository);
});

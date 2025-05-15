import 'package:esvilla_app/domain/use_cases/user/create_user_use_case.dart';
import 'package:esvilla_app/presentation/providers/user/user_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createUserUseCaseProvider = Provider<CreateUserUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return CreateUserUseCase(repository);
});


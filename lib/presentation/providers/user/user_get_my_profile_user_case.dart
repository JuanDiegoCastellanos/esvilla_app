import 'package:esvilla_app/domain/use_cases/get_my_profile_use_case.dart';
import 'package:esvilla_app/presentation/providers/user/user_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getMyProfileInfoUseCaseProvider = Provider<GetMyProfileUseCase>(
  (ref) {
    final userRepository = ref.watch(userRepositoryProvider);
    return GetMyProfileUseCase(userRepository);
  },
);
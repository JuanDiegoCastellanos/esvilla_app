import 'package:esvilla_app/presentation/providers/auth/auth_controller_state_notifier.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_state.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_token_provider.dart';
import 'package:esvilla_app/presentation/providers/auth/login_use_case_provider.dart';
import 'package:esvilla_app/presentation/providers/auth/register_use_case_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final registerUserCase = ref.watch(registerUseCaseProvider);
    final loginUseCase = ref.watch(loginUseCaseProvider);
    final authTokenStateNotifier = ref.watch(authTokenProvider.notifier);
    return AuthController(
        loginUseCase, registerUserCase, authTokenStateNotifier, ref);
  },
);
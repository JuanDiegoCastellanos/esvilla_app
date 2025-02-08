import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/use_cases/login_use_case.dart';
import 'auth_provider.dart';

// Proveedor de caso de uso para el login
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return LoginUseCase(authRepository);
});
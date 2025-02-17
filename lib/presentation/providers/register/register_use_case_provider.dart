import 'package:esvilla_app/domain/use_cases/register_use_cart.dart';
import 'package:esvilla_app/presentation/providers/register/register_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Proveedor de caso de uso para registro
final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  final registerRepository = ref.watch(registerRepositoryProvider);
  return RegisterUseCase(registerRepository);
});
import 'package:esvilla_app/presentation/providers/auth/auth_token_state.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_token_state_notifier.dart';
import 'package:esvilla_app/presentation/providers/storage/secure_storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authTokenProvider =
    StateNotifierProvider<AuthTokenStateNotifier, AuthTokenState>(
  (ref) => AuthTokenStateNotifier(ref.watch(secureStorageServiceProvider)),
);

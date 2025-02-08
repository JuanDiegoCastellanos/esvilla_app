
import 'package:esvilla_app/core/utils/secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageServiceProvider = Provider<SecureStorageServiceImpl>((ref) {
  return SecureStorageServiceImpl(const FlutterSecureStorage());
});
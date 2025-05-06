import 'package:flutter_riverpod/flutter_riverpod.dart';

final dropdownSelectedItemProvider = StateProvider<String>((ref) {
  return 'createdAt';
});
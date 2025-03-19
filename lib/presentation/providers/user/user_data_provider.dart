import 'package:esvilla_app/core/utils/secure_storage.dart';
import 'package:esvilla_app/presentation/providers/secure_storage_provider.dart';
import 'package:esvilla_app/presentation/providers/states/user_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserDataStateNotifier extends StateNotifier<UserState> {
  final SecureStorageService _storage;

  UserDataStateNotifier(this._storage) : super(const UserState.empty()) {
    // Cargar el token o tokens
    _loadTokens();
  }

  Future<void> _loadTokens() async {
    final name = await _storage.getASimpleToken('NAME');
    final email = await _storage.getASimpleToken('EMAIL');
    final documentNumber = await _storage.getASimpleToken('DOCUMENT_NUMBER');
    final phone = await _storage.getASimpleToken('PHONE');
    final mainAddress = await _storage.getASimpleToken('MAIN_ADDRESS');
    final role = await _storage.getASimpleToken('ROLE');
    state = UserState(
      name: name,
      email: email,
      documentNumber: documentNumber,
      phone: phone,
      mainAddress: mainAddress,
      role: role,
    );
  }

  Future<void> saveTokens(
      {required String userName,
      required String email,
      required String documentNumber,
      required String phone,
      required String mainAddress,
      required String role}) async {
    await _storage.saveASimpleToken('NAME', userName);
    await _storage.saveASimpleToken('EMAIL', email);
    await _storage.saveASimpleToken('DOCUMENT_NUMBER', documentNumber);
    await _storage.saveASimpleToken('PHONE', phone);
    await _storage.saveASimpleToken('MAIN_ADDRESS', mainAddress);
    await _storage.saveASimpleToken('ROLE', role);
    state = UserState(
      name: userName,
      email: email,
      documentNumber: documentNumber,
      phone: phone,
      mainAddress: mainAddress,
      role: role,
    );
  }

  Future<void> clearTokens() async {
    await _storage.clearASimpleToken('NAME');
    await _storage.clearASimpleToken('EMAIL');
    await _storage.clearASimpleToken('DOCUMENT_NUMBER');
    await _storage.clearASimpleToken('PHONE');
    await _storage.clearASimpleToken('MAIN_ADDRESS');
    await _storage.clearASimpleToken('ROLE');
    state = const UserState.empty();
  }

   Future<String?> getRole() async {
    if (state.role != null) return state.role; // Si ya está cargado, devolverlo
    final role = await _storage
        .getASimpleToken('ROLE'); // Volver a consultar si es necesario
    if (role != null) {
      state = UserState(
        name: state.name,
        email: state.email,
        documentNumber: state.documentNumber,
        phone: state.phone,
        mainAddress: state.mainAddress,
        role: role,
      );
    }
    return state.role;
  }


  Future<String?> getName() async {
    if (state.name != null) return state.name; // Si ya está cargado, devolverlo
    final name = await _storage
        .getASimpleToken('NAME'); // Volver a consultar si es necesario
    if (name != null) {
      state = UserState(
        name: name,
        email: state.email,
        documentNumber: state.documentNumber,
        phone: state.phone,
        mainAddress: state.mainAddress,
        role: state.role,
      );
    }
    return state.name;
  }

  Future<String?> getEmail() async {
    if (state.email != null) return state.email; // Si ya está cargado, devolverlo
    final email = await _storage
        .getASimpleToken('EMAIL'); // Volver a consultar si es necesario
    if (email != null) {
      state = UserState(
        name: state.name,
        email: email,
        documentNumber: state.documentNumber,
        phone: state.phone,
        mainAddress: state.mainAddress,
        role: state.role,
      );
    }
    return state.email;
  }

  Future<String?> getDocumentNumber() async {
    if (state.documentNumber != null) return state.documentNumber; // Si ya está cargado, devolverlo
    final documentNumber = await _storage
        .getASimpleToken('DOCUMENT_NUMBER'); // Volver a consultar si es necesario
    if (documentNumber != null) {
      state = UserState(
        name: state.name,
        email: state.email,
        documentNumber: documentNumber,
        phone: state.phone,
        mainAddress: state.mainAddress,
        role: state.role,
      );
    }
    return state.documentNumber;
  }

  Future<String?> getPhone() async {
    if (state.phone != null) return state.phone; // Si ya está cargado, devolverlo
    final phone = await _storage
        .getASimpleToken('PHONE'); // Volver a consultar si es necesario
    if (phone != null) {
      state = UserState(
        name: state.name,
        email: state.email,
        documentNumber: state.documentNumber,
        phone: phone,
        mainAddress: state.mainAddress,
        role: state.role,
      );
    }
    return state.phone;
  }

  Future<String?> getMainAddress() async {
    if (state.mainAddress != null) return state.mainAddress; // Si ya está cargado, devolverlo
    final mainAddress = await _storage
        .getASimpleToken('MAIN_ADDRESS'); // Volver a consultar si es necesario
    if (mainAddress != null) {
      state = UserState(
        name: state.name,
        email: state.email,
        documentNumber: state.documentNumber,
        phone: state.phone,
        mainAddress: mainAddress,
        role: state.role,
      );
    }
    return state.mainAddress;
  }
}

final userDataProvider = StateNotifierProvider<UserDataStateNotifier, UserState>(
  (ref) => UserDataStateNotifier(ref.watch(secureStorageServiceProvider)),
  );
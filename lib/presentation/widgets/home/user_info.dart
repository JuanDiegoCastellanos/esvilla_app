import 'package:esvilla_app/presentation/providers/auth/auth_controller_provider.dart';
import 'package:esvilla_app/presentation/providers/user/user_controller_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserInfo extends ConsumerStatefulWidget {
  const UserInfo({
    super.key,
  });

  @override
  ConsumerState<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends ConsumerState<UserInfo> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(authControllerProvider).isAuthenticated) {
        ref.read(userControllerProvider.notifier).getMyProfileInfo();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userControllerProvider);
    final isAuthenticated = ref.watch(authControllerProvider).isAuthenticated;

    if (!isAuthenticated) {
      return const SizedBox.shrink(); // O puedes mostrar un mensaje como Text('No autenticado');
    }

    return Padding(
      padding: EdgeInsets.zero,
      child: userData.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  userData.name ?? 'nombre de usuario',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                Text(
                  userData.documentNumber ?? 'numero de identificacion',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: Colors.black),
                )
              ],
            ),
    );
  }
}

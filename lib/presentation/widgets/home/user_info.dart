import 'package:esvilla_app/presentation/providers/user/user_controller_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserInfo extends ConsumerWidget {
  const UserInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userControllerProvider);
    return userData.maybeWhen(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Text(error.toString()),
      orElse: () => const Text('No autenticado'),
      data: (user) {
        return Padding(
          padding: EdgeInsets.zero,
          child: userData.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      user.name ?? 'nombre de usuario',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    Text(
                      user.documentNumber ?? 'numero de identificacion',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          color: Colors.black),
                    )
                  ],
                ),
        );
      },
    );
  }
}
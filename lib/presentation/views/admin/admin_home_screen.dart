import 'package:esvilla_app/presentation/providers/auth/auth_controller_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminHome extends ConsumerWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authControllerProvider.notifier);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Home'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  auth.logout();
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        )

        );
  }
}

import 'package:esvilla_app/core/config/app_router.dart';
import 'package:esvilla_app/data/repositories/user_repository.dart';
import 'package:esvilla_app/domain/use_cases/get_users_use_case.dart';
import 'package:esvilla_app/presentation/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider( create: (_) => UserRepository()),
        ProxyProvider<UserRepository, GetUsersUseCase>(
          update: (_, userRepository,__) => GetUsersUseCase(userRepository),
        ),
        ChangeNotifierProvider<UserController>(
          create: (context) => UserController(
            context.read<GetUsersUseCase>(),
          ), 
          )
      ],
      child: MaterialApp.router(
        routerConfig: appRouter,
        title: 'Esvilla App',
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

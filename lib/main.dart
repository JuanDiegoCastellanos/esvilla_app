import 'package:esvilla_app/core/config/app_router.dart';
import 'package:esvilla_app/core/config/app_theme.dart';
import 'package:flutter/material.dart';
import 'injection/injection.dart' as di;

void main() {
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp.router(
      routerConfig: AppRouter.appRouter,
      title: 'esvilla e.s.p ',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
    );
  }

 /*  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider( create: (_) => UserRepositoryImpl()),
        ProxyProvider<UserRepositoryImpl, GetUsersUseCase>(
          update: (_, userRepository,__) => GetUsersUseCase(userRepository),
        ),
        ChangeNotifierProvider<UserController>(
          create: (context) => UserController(
            context.read<GetUsersUseCase>(),
          ), 
          )
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter.appRouter,
        title: 'Esvilla App',
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
      ),
    );
  } */
}

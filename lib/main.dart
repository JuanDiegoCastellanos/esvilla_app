import 'package:esvilla_app/config/app_router.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp.router(
      routerConfig: appRouter,
      title: 'Esvilla App',
      debugShowCheckedModeBanner: false,
    );
  }
}
import 'package:esvilla_app/core/config/app_router.dart';
import 'package:esvilla_app/presentation/providers/conectivity_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerWidget {
  SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityStatus = ref.watch(connectivityProvider);

    debugPrint('Connectivity: ${connectivityStatus.isConnected}, '
        'Type: ${connectivityStatus.connectionType}');

    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: <Color>[
          connectivityStatus.isConnected
              ? const Color(0xFF82D8FF)
              : const Color.fromARGB(255, 110, 14, 200),
          const Color(0xFFFFFFFF)
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: const [0.56, 1.0],
      )),
      child: const SplashWidget(),
    ));
  }
}

class SplashWidget extends ConsumerWidget {
  const SplashWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                  height: 250,
                  width: 338,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: Color.fromRGBO(47, 39, 125, 1)),
                  transform: Matrix4.translationValues(300, -200, 0)
                    ..rotateZ(0.6)),
              Transform(
                transform: Matrix4.translationValues(0, -150, 0),
                child: Image.asset(
                  "assets/img/logoEsvillaOficial.png",
                  width: 316,
                  height: 142,
                ),
              ),
              Container(
                  height: 250,
                  width: 338,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: Color.fromRGBO(47, 39, 125, 1)),
                  transform: Matrix4.translationValues(-150, -250, 0)
                    ..rotateZ(0.6)),
              ElevatedButton(
                onPressed: () {
                  final goRouter = ref.watch(goRouterProvider);
                  //AppRouter.appRouter.push('/login');
                  goRouter.replace('/login');
                },
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(const Size(233, 50)),
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => const Color.fromRGBO(47, 39, 125, 1)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  )),
                ),
                child: const Text(
                  "Continuar",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Sniglet',
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

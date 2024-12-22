import 'package:esvilla_app/core/config/app_router.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Color(0xFF0F3420),
              Color(0xFF3B825B)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.47,1.0],
          )
        ),
        child: const SplashWidget(),
      )
    );
  }
}


class SplashWidget extends StatelessWidget {
  const SplashWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
                        color:  Color.fromRGBO(255, 255, 255, 0.664)
                      ),
                      transform: Matrix4.translationValues(300, -200, 0)
                        ..rotateZ(0.6)
                    ),
                Transform(
                  transform: Matrix4.translationValues(0, -150, 0),
                  child: Image.asset(
                    "assets/img/esvilla-titulo2.png",
                      width: 316,
                      height: 142,
                    ),
                ),
                Container(
                      height: 250,
                      width: 338,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        color:  Color.fromRGBO(255, 255, 255, 0.664)
                      ),
                      transform: Matrix4.translationValues(-150, -250, 0)
                        ..rotateZ(0.6)
                ),
                ElevatedButton(
                  onPressed: ()=>{
                    appRouter.go('/login')
                  },
                   style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(const Size(233, 50)),
                    backgroundColor: MaterialStateColor.resolveWith((states) => const Color.fromRGBO(255, 255, 255, 1)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),)),
                    ),
                    child:  const Text(
                    "Continuar", 
                    style:  TextStyle(
                      color:  Color.fromARGB(255, 0, 0, 0),
                      fontSize: 24,
                      fontWeight: FontWeight.w500
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
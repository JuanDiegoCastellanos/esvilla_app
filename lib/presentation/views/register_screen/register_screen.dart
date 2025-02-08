import 'package:esvilla_app/core/config/app_router.dart';
import 'package:esvilla_app/core/constants/app_texts.dart';
import 'package:esvilla_app/presentation/providers/auth_controller_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterScreen extends ConsumerWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(authControllerProvider.notifier);
    const inputColor = Color.fromRGBO(226, 246, 255, 0.4);
    final goRouter = ref.read(goRouterProvider);

    return Scaffold(
      backgroundColor: Color(0xFF82D8FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Transform(
                transform: Matrix4.identity(),
                child: Image.asset(
                  'assets/img/logoEsvillaOficial.png',
                  width: 260,
                  height: 100,
                ),
              ),
              // image
              Container(
                width: MediaQuery.of(context).size.width,
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/img/imgLogin.png'),
                        fit: BoxFit.fill)),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Registro',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 40,
                        color: Color.fromRGBO(47, 39, 125, 1),
                        fontFamily: 'Sniglet',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(left: 20),
                      child: const Text(
                        'Nombre :',
                        style: TextStyle(fontFamily: 'Sniglet', fontSize: 19),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 40,
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          fillColor: inputColor,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF4F78FF),
                              width: 2.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF4F78FF), // Color del borde al enfocar
                              width: 2.5, // Grosor del borde al enfocar
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF4F78FF), // Color del borde al habilitar
                              width: 2.5, // Grosor del borde al habilitar
                            ),
                          ),

                        ),
                        textAlignVertical: TextAlignVertical.top,
                        cursorHeight: 30,
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'Sniglet',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(left: 20),
                      child: const Text(
                        'Nro. Documento :',
                        style: TextStyle(fontFamily: 'Sniglet', fontSize: 19),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 40,
                      child: TextField(
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          fillColor: inputColor,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.lightBlue.shade900,
                              width: 4,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors
                                  .lightBlue, // Color del borde al enfocar
                              width: 4, // Grosor del borde al enfocar
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF4F78FF), // Color del borde al habilitar
                              width: 2.5, // Grosor del borde al habilitar
                            ),
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Sniglet',
                          ),
                        textAlignVertical: TextAlignVertical.top,
                        cursorHeight: 30,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(left: 20),
                      child: const Text(
                        'Email :',
                        style: TextStyle(fontFamily: 'Sniglet', fontSize: 19),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 40,
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          fillColor: inputColor,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF4F78FF),
                              width: 2.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF4F78FF), // Color del borde al enfocar
                              width: 2.5, // Grosor del borde al enfocar
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF4F78FF), // Color del borde al habilitar
                              width: 2.5, // Grosor del borde al habilitar
                            ),
                          ),

                        ),
                        textAlignVertical: TextAlignVertical.top,
                        cursorHeight: 30,
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'Sniglet',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(left: 20),
                      child: const Text(
                        'Teléfono :',
                        style: TextStyle(fontFamily: 'Sniglet', fontSize: 19),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 40,
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          fillColor: inputColor,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF4F78FF),
                              width: 2.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF4F78FF), // Color del borde al enfocar
                              width: 2.5, // Grosor del borde al enfocar
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF4F78FF), // Color del borde al habilitar
                              width: 2.5, // Grosor del borde al habilitar
                            ),
                          ),

                        ),
                        textAlignVertical: TextAlignVertical.top,
                        cursorHeight: 30,
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'Sniglet',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(left: 20),
                      child: const Text(
                        'Clave :',
                        style: TextStyle(fontFamily: 'Sniglet', fontSize: 19),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 40,
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          fillColor: inputColor,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF4F78FF),
                              width: 2.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF4F78FF), // Color del borde al enfocar
                              width: 2.5, // Grosor del borde al enfocar
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF4F78FF), // Color del borde al habilitar
                              width: 2.5, // Grosor del borde al habilitar
                            ),
                          ),

                        ),
                        textAlignVertical: TextAlignVertical.top,
                        cursorHeight: 30,
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'Sniglet',
                        ),
                      ),
                    ),
                     const SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(left: 20),
                      child: const Text(
                        'Clave nuevamente :',
                        style: TextStyle(fontFamily: 'Sniglet', fontSize: 19),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 40,
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          fillColor: inputColor,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF4F78FF),
                              width: 2.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF4F78FF), // Color del borde al enfocar
                              width: 2.5, // Grosor del borde al enfocar
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF4F78FF), // Color del borde al habilitar
                              width: 2.5, // Grosor del borde al habilitar
                            ),
                          ),

                        ),
                        textAlignVertical: TextAlignVertical.top,
                        cursorHeight: 30,
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'Sniglet',
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    ElevatedButton(
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all(
                                  const Size(233, 50)),
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) =>
                                      const Color.fromRGBO(47, 39, 125, 1)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              )),
                            ),
                            onPressed: () async {

                              await Future.delayed(const Duration(seconds: 1));
                              goRouter.push('/home');
                              
                            },
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontFamily: 'Sniglet'
                                  ),
                            ),
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: const Text(
                              AppTexts.termsAndPrivacy,
                              style: TextStyle(
                                fontFamily: 'Sniglet',
                                fontSize: 16
                              ),
                              textAlign: TextAlign.center,
                              ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

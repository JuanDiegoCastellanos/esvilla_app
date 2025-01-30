import 'package:esvilla_app/core/config/app_router.dart';
import 'package:esvilla_app/core/constants/app_texts.dart';
import 'package:esvilla_app/presentation/providers/auth_controller_provider.dart';
import 'package:esvilla_app/presentation/widgets/shared/button_rectangular.dart';
import 'package:esvilla_app/presentation/widgets/shared/text_field_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'assets/img/imgLogin.png',
                  fit: BoxFit.fill,
                ),
              ), // image
              Column(
                children: [
                  Transform(
                    transform: Matrix4.translationValues(0, -90, 0),
                    child: const Text(
                      'Iniciar Sesión',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 35,
                        color: Color.fromRGBO(47, 39, 125, 1),
                        fontFamily: 'Sniglet',
                      ),
                    ),
                  ),
                  Container(
                    transform: Matrix4.translationValues(0, -50, 0),
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(left: 20),
                    child: const Text(
                      AppTexts.welcomeTitle,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 21,
                        color: Colors.black,
                        fontFamily: 'Sniglet',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    transform: Matrix4.translationValues(0, -40, 0),
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(left: 20),
                    child: const Text(
                      'Documento de identidad :',
                      style: TextStyle(fontFamily: 'Sniglet', fontSize: 19),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    transform: Matrix4.translationValues(0, -40, 0),
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 40,
                    child: TextFieldBox(
                      controller: emailController,
                      obscureText: false,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    transform: Matrix4.translationValues(0, -40, 0),
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(left: 20),
                    child: const Text(
                      'Clave :',
                      style: TextStyle(fontFamily: 'Sniglet', fontSize: 19),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    transform: Matrix4.translationValues(0, -40, 0),
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 40,
                    child: TextFieldBox(
                      controller: passwordController,
                      obscureText: true,
                    ),
                  ),
                  ButtonRectangular(
                    onPressedFunction: () async {
                      FocusScope.of(context).unfocus();
                      final authController =
                          ref.read(authControllerProvider.notifier);

                      final email = emailController.text;
                      final password = passwordController.text;

                      if (email.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                'Por favor, completa todos los campos',
                              )),
                        );
                        return;
                      }
                      try {
                        await authController.login(email, password);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Login error: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    title: 'Login',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () => router.push('/register'),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF4F78FF),
                          decoration: TextDecoration.underline),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: const Text(
                      AppTexts.termsAndPrivacy,
                      style: TextStyle(fontFamily: 'Sniglet', fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

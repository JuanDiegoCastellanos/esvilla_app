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
      backgroundColor: Color(0xFF82D8FF),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Transform(
                transform: Matrix4.identity(),
                child: Image.asset(
                  'assets/img/logoEsvillaOficial.png',
                  width: 260,
                  height: 166,
                ),
              ),
              // image
              Container(
                width: MediaQuery.of(context).size.width,
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/img/imgLogin.png'),
                        fit: BoxFit.fill)),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Iniciar Sesión',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 35,
                        color: Color.fromRGBO(47, 39, 125, 1),
                        fontFamily: 'Sniglet',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
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
                    const SizedBox(height: 60),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(left: 20),
                      child: const Text(
                        'Documento de identidad :',
                        style: TextStyle(fontFamily: 'Sniglet', fontSize: 19),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 40,
                      child: TextFieldBox(
                        controller: emailController,
                        obscureText: false,
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
                      child: TextFieldBox(
                        controller: passwordController,
                        obscureText: true,
                      ),
                    ),
                    const SizedBox(height: 60),
                    ButtonRectangular(
                      onPressedFunction: () => onPressedButtonFunction(ref, context),
                      title: 'Login',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        child: GestureDetector(
                      onTap: () => router.push('/register'),
                      child: const Text(
                        'Register',
                        style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF4F78FF),
                            decoration: TextDecoration.underline),
                      ),
                    )),
                    const SizedBox(
                      height: 30,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  onPressedButtonFunction(WidgetRef ref, BuildContext context) async {
    final email = emailController.text;
    final password = passwordController.text;
    final authState = ref.watch(authControllerProvider);
    final authController = ref.read(authControllerProvider.notifier);
    try {
      await authController.login(email, password);
      if (authState.isAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful')),
        );
        ref.read(goRouterProvider).pushReplacement('/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: invalid email or password'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

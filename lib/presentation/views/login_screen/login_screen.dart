import 'package:esvilla_app/core/config/app_router.dart';
import 'package:esvilla_app/core/constants/app_texts.dart';
import 'package:esvilla_app/presentation/providers/auth_controller_provider.dart';
import 'package:esvilla_app/presentation/widgets/shared/button_rectangular.dart';
import 'package:esvilla_app/presentation/widgets/shared/text_field_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    // Oculta el teclado
    //FocusScope.of(context).unfocus();

    if (_emailController.text.trim().isNotEmpty &&
        _passwordController.text.trim().isNotEmpty) {
      try {
        await ref.read(authControllerProvider.notifier).login(
              _emailController.text.trim(),
              _passwordController.text.trim(),
            );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Bienvenido!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Los campos son obligatorios'),
          duration: Duration(seconds: 4),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'assets/img/imgLogin.png',
                  fit: BoxFit.contain,
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
                      controller: _emailController,
                      obscureText: false,
                      errorMessage: _passwordController.text.isEmpty
                          ? 'El campo es obligatorio'
                          : '',
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
                      controller: _passwordController,
                      obscureText: true,
                      errorMessage: _passwordController.text.isEmpty
                          ? 'El campo es obligatorio'
                          : '',
                    ),
                  ),
                  //authState.isLoading ? const CircularProgressIndicator() :
                  ButtonRectangular(
                    onPressedFunction: authState.isLoading ? null : _login,
                    child: authState.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Iniciar Sesión',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontFamily: 'Sniglet')),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      final goRouter = ref.read(goRouterProvider);
                      goRouter.push('/register');
                    },
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

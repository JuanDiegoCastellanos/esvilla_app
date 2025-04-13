import 'package:esvilla_app/core/config/app_router.dart';
import 'package:esvilla_app/core/constants/app_texts.dart';
import 'package:esvilla_app/core/error/app_exceptions.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_controller_provider.dart';
import 'package:esvilla_app/presentation/widgets/shared/button_rectangular.dart';
import 'package:esvilla_app/presentation/widgets/shared/text_field_form_esvilla.dart';
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
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {

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
            content: Text(
              '¡Bienvenido!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            backgroundColor: Colors.green,
          ),
        );
      } on AppException catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text(
                e.code == 401 ? 'Email o contraseña incorrectos' : e.message,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(
            child: Text(
              'Los campos son obligatorios',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          duration: Duration(seconds: 4),
          backgroundColor: Colors.red,
        ),
      );
    }
    }
  }
  String? _validarCampo(String? value, String campo) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa $campo';
    }
    return null;
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
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Transform(
                      transform: Matrix4.translationValues(0, -90, 0),
                      child: const Text(
                        'Iniciar Sesión',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 35,
                            color: Color.fromRGBO(47, 39, 125, 1),
                            fontWeight: FontWeight.w400),
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
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFieldFormEsvilla(
                        name: 'Documento de identidad o Email',
                        controller: _emailController,
                        inputType: TextInputType.text,
                        validator: (value) => _validarCampo(value, 'Documento'),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFieldFormEsvilla(
                        name: 'Clave',
                        controller: _passwordController,
                        inputType: TextInputType.visiblePassword,
                        obscureText: true,
                        validator: (value) => _validarCampo(value, 'Clave'),
                      ),
                    ),
                    const SizedBox(height: 30),
                    //authState.isLoading ? const CircularProgressIndicator() :
                    ButtonRectangular(
                      onPressedFunction: authState.isLoading ? null : _login,
                      child: authState.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Iniciar Sesión',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600),
                            ),
                    ),
                    const SizedBox(
                      height: 20,
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
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF4F78FF),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: const Text(
                        AppTexts.termsAndPrivacy,
                        style: TextStyle(
                          fontFamily: 'Sniglet',
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
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

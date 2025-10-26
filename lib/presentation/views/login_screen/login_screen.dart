import 'package:esvilla_app/core/config/app_router.dart';
import 'package:esvilla_app/core/constants/app_texts.dart';
import 'package:esvilla_app/core/error/app_exceptions.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_controller_state_notifier.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_state.dart';
import 'package:esvilla_app/presentation/widgets/shared/button_rectangular.dart';
import 'package:esvilla_app/presentation/widgets/shared/text_field_form_esvilla.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      await ref.read(authControllerProvider.notifier).login(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
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

    ref.listen<AuthState>(authControllerProvider, (prev, next) {
      // Si cambió el mensaje de error, muéstralo
      if (next.error != null && next.error != prev?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(milliseconds: 500),
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
      }

      // Si pasó de loading a autenticado con éxito, muestro bienvenida
      final wasLoading = prev?.isLoading ?? false;
      if (wasLoading && next.isAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(milliseconds: 500),
            content: Text('¡Bienvenido!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });

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
                      transform: Matrix4.translationValues(0, -120, 0),
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
                      transform: Matrix4.translationValues(0, -110, 0),
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
                    Container(
                      transform: Matrix4.translationValues(0, -80, 0),
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: TextFieldFormEsvilla(
                        name: 'Documento de identidad o Email',
                        maxLength: 200,
                        controller: _emailController,
                        inputType: TextInputType.text,
                        validator: (value) => _validarCampo(value, 'Documento'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      transform: Matrix4.translationValues(0, -80, 0),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFieldFormEsvilla(
                        name: 'Clave',
                        controller: _passwordController,
                        inputType: TextInputType.visiblePassword,
                        obscureText: _isObscure,
                        maxLength: 50,
                        minLength: 8,
                        validator: (value) => _validarCampo(value, 'Clave'),
                        suffixIcon: IconButton(
                            color: Colors.blue.shade300,
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                            icon: Icon(Icons.remove_red_eye)),
                      ),
                    ),
                    //authState.isLoading ? const CircularProgressIndicator() :
                    Container(
                      transform: Matrix4.translationValues(0, -70, 0),
                      child: ButtonRectangular(
                        onPressedFunction: authState.isLoading ? null : _login,
                        child: authState.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                'Iniciar Sesión',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),
                    Container(
                      transform: Matrix4.translationValues(0, -50, 0),
                      child: GestureDetector(
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
                            decorationStyle: TextDecorationStyle.dotted,
                            decorationColor: Color(0xFF4F78FF),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        launchPrivacy();
                      },
                      child: Container(
                        transform: Matrix4.translationValues(0, -30, 0),
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: const Text(
                          AppTexts.termsAndPrivacy,
                          style: TextStyle(
                            color: Color(0xFF4F78FF),
                            decoration: TextDecoration.underline,
                            decorationStyle: TextDecorationStyle.dotted,
                            decorationColor: Color(0xFF4F78FF),
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.center,
                        ),
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

  Future<void> launchPrivacy() async {
    try {
      final url = Uri.parse('http://www.esvilla-esp.gov.co/politicas/');
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      throw AppException(message: 'Error al abrir Link de privacidad $e');
    }
  }
}

import 'package:esvilla_app/core/config/app_logger.dart';
import 'package:esvilla_app/core/constants/app_texts.dart';
import 'package:esvilla_app/core/error/app_exceptions.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_controller_state_notifier.dart';
import 'package:esvilla_app/presentation/widgets/shared/text_field_form_esvilla.dart';
import 'package:esvilla_app/presentation/widgets/shared/address_autocomplete_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _documentController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordAgainController = TextEditingController();
  final _direccionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool obscurePwd1 = true;
  bool obscurePwd2 = true;

  @override
  void dispose() {
    _nameController.dispose();
    _documentController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    _passwordController.dispose();
    _passwordAgainController.dispose();
    _direccionController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    // Oculta el teclado
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    final name = _nameController.text.trim();
    final document = _documentController.text.trim();
    final email = _emailController.text.trim();
    final telefono = _telefonoController.text.trim();
    final password = _passwordController.text.trim();
    final passwordAgain = _passwordAgainController.text.trim();
    final direccion = _direccionController.text.trim();

    if (name.isNotEmpty &&
        document.isNotEmpty &&
        email.isNotEmpty &&
        telefono.isNotEmpty &&
        password.isNotEmpty &&
        passwordAgain.isNotEmpty &&
        direccion.isNotEmpty) {
      if (password == passwordAgain) {
        try {
          await ref.read(authControllerProvider.notifier).register(
                name,
                document,
                email,
                telefono,
                password,
                direccion,
              );
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Bienvenido!'),
              backgroundColor: Colors.green,
            ),
          );
        } on AppException catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.code == 401
                  ? 'Email o contraseña incorrectos'
                  : e.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Las contraseñas no coinciden'),
            duration: Duration(seconds: 4),
            backgroundColor: Colors.red,
          ),
        );
        return;
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
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/img/imgLogin.png',
                fit: BoxFit.contain,
              ),
            ),
            Form(
              key: _formKey,
              child: Container(
                transform: Matrix4.translationValues(0, -80, 0),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    const Text(
                      'Registro',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 35,
                        color: Color.fromRGBO(47, 39, 125, 1),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 20),
                    newInputField(_nameController, 'Nombres y Apellidos', 200,
                        6, null, _validarCampo),
                    const SizedBox(height: 20),
                    newInputField(_documentController, 'Documento de identidad',
                        20, 10, null, _validarCampo),
                    const SizedBox(height: 20),
                    newInputField(_emailController, 'Correo electrónico', 200,
                        30, null, _validarCampo),
                    const SizedBox(height: 20),
                    newInputField(_telefonoController, 'Teléfono', 20, 10, null,
                        _validarCampo),
                    const SizedBox(height: 20),
                    AddressAutocompleteField(
                      controller: _direccionController,
                      name: 'Dirección',
                      maxLength: 500,
                      minLength: 6,
                      validator: (value) =>
                          _validarCampo(value, 'una dirección'),
                    ),
                    const SizedBox(height: 20),
                    newInputField(
                        _passwordController,
                        'Contraseña',
                        30,
                        8,
                        IconButton(
                            onPressed: () {
                              setState(() {
                                obscurePwd1 = !obscurePwd1;
                                AppLogger.d('obscureField: $obscurePwd1');
                              });
                            },
                            icon: Icon(Icons.remove_red_eye)),
                        _validarCampo,
                        obscure: obscurePwd1),
                    const SizedBox(height: 20),
                    newInputField(
                        _passwordAgainController,
                        'Repetir Contraseña',
                        30,
                        8,
                        IconButton(
                            onPressed: () {
                              setState(() {
                                obscurePwd2 = !obscurePwd2;
                                AppLogger.d('obscureField: $obscurePwd2');
                              });
                            },
                            icon: Icon(Icons.remove_red_eye)),
                        _validarCampo,
                        obscure: obscurePwd2),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      style: ButtonStyle(
                        fixedSize: WidgetStateProperty.all(const Size(233, 50)),
                        backgroundColor: WidgetStateColor.resolveWith(
                            (states) => const Color.fromRGBO(47, 39, 125, 1)),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                      onPressed: _register,
                      child: authState.isLoading
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.red),
                            )
                          : const Text(
                              'Register',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600),
                            ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        launchPrivacy();
                      },
                      child: Container(
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
            ),
          ],
        ),
      ),
    ));
  }

  Future<void> launchPrivacy() async {
    try {
      final url = Uri.parse('http://www.esvilla-esp.gov.co/politicas/');
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      throw AppException(message: 'Error al abrir Link de privacidad $e');
    }
  }

  Widget newInputField(
      TextEditingController controller,
      String name,
      int maxLength,
      int minLength,
      Widget? suffixIcon,
      String? Function(String?, String) validatorFunction,
      {bool obscure = false}) {
    return TextFieldFormEsvilla(
      inputType: TextInputType.text,
      controller: controller,
      name: name,
      maxLength: maxLength,
      minLength: minLength,
      suffixIcon: suffixIcon,
      validator: (value) => validatorFunction(value, name),
      obscureText: obscure,
    );
  }
}
